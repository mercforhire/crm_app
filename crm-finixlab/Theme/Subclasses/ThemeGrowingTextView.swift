//
//  ThemeGrowingTextView.swift
//  crm-finixlab
//
//  Created by Leon Chen on 2021-07-10.
//

import UIKit
import GrowingTextView

class ThemeGrowingTextView: GrowingTextView {

    private let themeManager = ThemeManager.shared
    private var observer: NSObjectProtocol?
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupUI()
    }
    
    func setupUI() {
        guard let theme = themeManager.themeData?.textFieldTheme else { return }
        
        backgroundColor = UIColor.fromRGBString(rgbString: theme.backgroundColor)
        if let borderColor = UIColor.fromRGBString(rgbString: theme.borderColor ?? "") {
            addBorder(color: borderColor)
        }
        font = theme.font.toFont()
        textColor = UIColor.fromRGBString(rgbString: theme.textColor)
        roundCorners()
        
        if observer == nil {
            observer = NotificationCenter.default.addObserver(forName: ThemeManager.Notifications.ThemeChanged,
                                                              object: nil,
                                                              queue: OperationQueue.main) { [weak self] (notif) in
                self?.setupUI()
            }
        }
    }

    deinit {
        if observer != nil {
            NotificationCenter.default.removeObserver(observer!)
        }
    }
}
