//
//  FeedParser.swift
//  ImageOfTheDay
//
//  Created by Dmytro Anokhin on 23/03/2021.
//

import Foundation
import Combine


/// Parser for a news feed in RSS or Atom format
///
/// RSS and Atom feeds are very similar, and for purposes of the app both can be parsed using one parser.
class FeedParser: NSObject {

    private enum FeedType {

        case unknown

        case atom

        case rss
    }

    private struct State {

        /// Stack of XML nodes. Nodes pushed when the parser encounters a start tag and popped when encounters an end tag.
        var stack: [XMLNode] = []

        /// What type of the feed is this.
        var feedType: FeedType = .unknown

        /// Items parsed so far.
        var items: [Item] = []
    }

    private struct XMLNode {

        /// Element name
        var name: String

        /// Data type attribute: text, html, etc.
        var type: String?

        /// href attribute
        var href: String?

        /// url attribute
        var url: String?

        /// Characters encountered
        var string: String = ""

        var children: [XMLNode] = []
    }

    static func parse(data: Data) -> Future<Feed, Error> {
        Future() { promise in
            let parser = FeedParser(data: data)

            parser.parse { result in
                let _ = parser // keep alive
                promise(result)
            }
        }
    }

    init?(url: URL) {
        guard let parser = XMLParser(contentsOf: url) else {
            return nil
        }

        self.parser = parser

        super.init()
    }

    init(data: Data) {
        parser = XMLParser(data: data)
        super.init()
    }

    private let parser: XMLParser

    func parse(completion: @escaping (_ result: Result<Feed, Error>) -> Void) {
        self.completion = completion
        parser.delegate = self
        parser.parse()
    }

    private var state: State!

    private var completion: ((_ result: Result<Feed, Error>) -> Void)?

    /// Checks whenever XML element name is an item in regards to the feed type.
    ///
    /// Returns `true` if an `Item` object can be constructed.
    private func makeItem(_ node: XMLNode) -> Item? {
        switch state.feedType {
            case .atom:
                return makeItemFromAtomEntry(node)
            case .rss:
                return makeItemFromRSSItem(node)
            default:
                assertionFailure("Unknown feed type")
                return nil
        }
    }

    private func makeItemFromAtomEntry(_ node: XMLNode) -> Item? {
        guard node.name == "entry" else {
            return nil
        }

        var idNode: XMLNode?      // id
        var titleNode: XMLNode?   // title
        var previewNode: XMLNode? // media:preview

        for child in node.children {
            switch child.name {
                case "id":
                    idNode = child
                case "title":
                    titleNode = child
                case "media:preview":
                    previewNode = child
                default:
                    break
            }
        }

        guard let id = idNode?.string,
              let title = titleNode?.string,
              let preview = previewNode?.url, let imageURL = URL(string: preview) else {
            print("Atom entry missing required fields")
            return nil
        }

        return Item(title: title, imageURL: imageURL, id: id)
    }

    private func makeItemFromRSSItem(_ node: XMLNode) -> Item? {
        guard node.name == "item" else {
            return nil
        }

        var guidNode: XMLNode?      // guid
        var titleNode: XMLNode?     // title
        var enclosureNode: XMLNode? // enclosure with type image

        for child in node.children {
            switch child.name {
                case "guid":
                    guidNode = child
                case "title":
                    titleNode = child
                case "enclosure":
                    if let type = child.type, type.hasPrefix("image") {
                        enclosureNode = child
                    }
                default:
                    break
            }
        }

        guard let id = guidNode?.string,
              let title = titleNode?.string,
              let preview = enclosureNode?.url, let imageURL = URL(string: preview) else {
            print("RSS item missing required fields")
            return nil
        }

        return Item(title: title, imageURL: imageURL, id: id)
    }
}


extension FeedParser: XMLParserDelegate {

    func parserDidStartDocument(_ parser: XMLParser) {
        state = State()
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        let feed = Feed(items: state.items)
        completion?(.success(feed))
        completion = nil
    }

    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String]) {

        switch elementName.lowercased() {
            case "feed":
                state.feedType = .atom
            case "rss":
                state.feedType = .rss
            default:
                break
        }

        let node = XMLNode(name: elementName,
                           type: attributeDict["type"],
                           href: attributeDict["href"],
                           url: attributeDict["url"])

        state.stack.append(node)
    }

    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {

        let node = state.stack.removeLast()

        assert(node.name == elementName)

        if let item = makeItem(node) {
            state.items.append(item)
        }
        else if !state.stack.isEmpty {
            var parent = state.stack.removeLast()
            parent.children.append(node)
            state.stack.append(parent)
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        var node = state.stack.removeLast()
        node.string += string
        state.stack.append(node)
    }

    func parser(_ parser: XMLParser, parseErrorOccurred error: Error) {
        completion?(.failure(error))
        completion = nil
    }
}
