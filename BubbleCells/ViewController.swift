//
//  ViewController.swift
//  BubbleCells
//
//  Created by Yury Korolev on 12/29/15.
//  Copyright © 2015 Yury Korolev. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import LoremIpsum

struct CellMeta {
    var text: String
    var header: String?
    var mine: Bool
}

class MessageCellNode: ASCellNode {
    private let _mine: Bool
    private let _textNode = ASTextNode()
    private let _bubbleNode = ASDisplayNode()
    private let _headerTextNode: ASTextNode?
    
    init(meta: CellMeta) {
        _mine = meta.mine
        
        if let header = meta.header {
            _headerTextNode = ASTextNode()
            _headerTextNode?.attributedString = NSAttributedString(
                string: header,
                attributes: [NSForegroundColorAttributeName: UIColor.grayColor()]
            )
            _headerTextNode?.alignSelf = .Center
        } else {
            _headerTextNode = nil
        }
        
       super.init()
        
        selectionStyle = .None
        
        _bubbleNode.backgroundColor = _mine ? .blueColor() : .greenColor()
        _bubbleNode.cornerRadius = 5
        _bubbleNode.clipsToBounds = true
        _bubbleNode.flexShrink = true
        addSubnode(_bubbleNode)
       
        _textNode.attributedString = NSAttributedString(
            string: meta.text,
            attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()]
        )
        _textNode.flexShrink = true
        _textNode.alignSelf = _mine ? .End : .Start
        addSubnode(_textNode)
        
        if let headerNode = _headerTextNode {
            addSubnode(headerNode)
        }
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec! {
        let spacer = ASLayoutSpec()
        spacer.flexGrow = true
        spacer.flexBasis = ASRelativeDimensionMakeWithPercent(0.3)
        
        let bubbleSpec = ASBackgroundLayoutSpec(
            child: ASInsetLayoutSpec(
                insets: UIEdgeInsetsMake(4, 4, 4, 4),
                child: _textNode
            ),
            background: _bubbleNode
        )
        
        bubbleSpec.flexShrink = true
        
        let rowSpec = ASInsetLayoutSpec(
            insets: UIEdgeInsetsMake(4, 6, 4, 8),
            child:
            ASStackLayoutSpec(
                direction: .Horizontal,
                spacing: 4,
                justifyContent: _mine ? .End : .Start,
                alignItems: .Start,
                children: _mine ? [spacer, bubbleSpec] : [bubbleSpec, spacer]
            )
        )
       
        if let headerTextNode = _headerTextNode {
            return ASStackLayoutSpec(
                direction: .Vertical,
                spacing: 8,
                justifyContent: .Start,
                alignItems: .Stretch,
                children: [headerTextNode, rowSpec]
            )
        } else {
            return rowSpec
        }
        
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent!) -> Bool {
        let p = convertPoint(point, toNode: _bubbleNode)
        return _bubbleNode.pointInside(p, withEvent: event)
    }
    
    override var selected: Bool {
        get {
            return super.selected
        }
        set {
            super.selected = newValue
            if newValue {
                _bubbleNode.backgroundColor = UIColor.darkGrayColor()
            } else {
                _bubbleNode.backgroundColor = _mine ? .blueColor() : .greenColor()
            }
        }
    }
    
    override var highlighted: Bool {
        get {
            return super.highlighted
        }
        set {
            super.highlighted = newValue
            if newValue {
                _bubbleNode.backgroundColor = UIColor.lightGrayColor()
            } else {
                _bubbleNode.backgroundColor = _mine ? .blueColor() : .greenColor()
            }
        }
    }
}

class ViewController: UIViewController, ASTableViewDataSource, ASTableViewDelegate {
    
    private let _tableView = ASTableView()
    private var _cells: [CellMeta] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
        _tableView.separatorStyle = .None
        _tableView.asyncDataSource = self
        _tableView.asyncDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(_tableView)
        
        _cells = _generateCells()
    }
    
    func _generateCells() -> [CellMeta] {
        var cells = [CellMeta]()
        
        for _ in 0..<100 {
            let mine = random() % 2 == 0
            let text = LoremIpsum.sentence()
            let header = random() % 8 == 0 ? LoremIpsum.word() : nil
            
            cells.append(CellMeta(text: text, header: header, mine: mine))
        }
        
        return cells
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        _tableView.frame = view.bounds
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return _cells.count
    }
    
    func tableView(tableView: ASTableView!, nodeForRowAtIndexPath indexPath: NSIndexPath!) -> ASCellNode! {
        let cell = _cells[indexPath.row]
        return MessageCellNode(meta: cell)
    }

}

