//
//  VpnCollectionViewItem.swift
//  rvcmac
//
//  Created by Nikita Titov on 22/07/2017.
//  Copyright © 2017 Ribose. All rights reserved.
//

import Cocoa

class VpnCollectionViewItem: NSCollectionViewItem {

    @IBOutlet weak var titleTextField: NSTextField!
    
    func assertCheck() {
        assert(self.titleTextField != nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.assertCheck()
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        // super.prepareForReuse() leads to a crash
        self.titleTextField.stringValue = ""
    }
    
    var item: Vpn! {
        didSet {
            self.titleTextField.stringValue = item.title
        }
    }
    
}
