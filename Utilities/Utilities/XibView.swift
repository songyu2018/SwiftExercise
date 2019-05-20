//
//  NibView.swift
//  UtilityFramework
//
//

import UIKit


@IBDesignable
open class XibView : UIView {
    
    var contentView:UIView?
    @IBInspectable var nibName:String?

    
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
    }
    
    open func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
    
    open func loadViewFromNib() -> UIView? {
        guard let nibName = nibName else { return nil }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        contentView?.prepareForInterfaceBuilder()
    }

}
