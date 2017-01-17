//
//  UIView+AutoLayout.swift
//  TGWeibo
//
//  Created by Theodore Guo on 17/1/17.
//  Copyright © 2017 Theodore Guo. All rights reserved.
//

import UIKit

/**
 Alignment enumerations, set subview's position referring to superview
 
 - TopLeft:      top left referring to superview
 - TopRight:     top right referring to superview
 - TopCenter:    top center referring to superview
 - BottomLeft:   bottom left referring to superview
 - BottomRight:  bottom right referring to superview
 - BottomCenter: bottom center referring to superview
 - CenterLeft:   center left referring to superview
 - CenterRight:  center right referring to superview
 - Center:       center referring to superview
 */
public enum TG_AlignType {
    case TopLeft
    case TopRight
    case TopCenter
    case BottomLeft
    case BottomRight
    case BottomCenter
    case CenterLeft
    case CenterRight
    case Center
    
    private func layoutAttributes(isInner: Bool, isVertical: Bool) -> TG_LayoutAttributes {
        let attributes = TG_LayoutAttributes()
        
        switch self {
            case .TopLeft:
                attributes.horizontals(.Left, to: .Left).verticals(.Top, to: .Top)
                
                if isInner {
                    return attributes
                } else if isVertical {
                    return attributes.verticals(.Bottom, to: .Top)
                } else {
                    return attributes.horizontals(.Right, to: .Left)
                }
            
            case .TopRight:
                attributes.horizontals(.Right, to: .Right).verticals(.Top, to: .Top)
                
                if isInner {
                    return attributes
                } else if isVertical {
                    return attributes.verticals(.Bottom, to: .Top)
                } else {
                    return attributes.horizontals(.Left, to: .Right)
                }
            
            case .BottomLeft:
                attributes.horizontals(.Left, to: .Left).verticals(.Bottom, to: .Bottom)
                
                if isInner {
                    return attributes
                } else if isVertical {
                    return attributes.verticals(.Top, to: .Bottom)
                } else {
                    return attributes.horizontals(.Right, to: .Left)
                }
            
            case .BottomRight:
                attributes.horizontals(.Right, to: .Right).verticals(.Bottom, to: .Bottom)
                
                if isInner {
                    return attributes
                } else if isVertical {
                    return attributes.verticals(.Top, to: .Bottom)
                } else {
                    return attributes.horizontals(.Left, to: .Right)
                }
            
            case .TopCenter:
                attributes.horizontals(.CenterX, to: .CenterX).verticals(.Top, to: .Top)
                return isInner ? attributes : attributes.verticals(.Bottom, to: .Top)
            
            case .BottomCenter:
                attributes.horizontals(.CenterX, to: .CenterX).verticals(.Bottom, to: .Bottom)
                return isInner ? attributes : attributes.verticals(.Top, to: .Bottom)
            
            case .CenterLeft:
                attributes.horizontals(.Left, to: .Left).verticals(.CenterY, to: .CenterY)
                return isInner ? attributes : attributes.horizontals(.Right, to: .Left)
            
            case .CenterRight:
                attributes.horizontals(.Right, to: .Right).verticals(.CenterY, to: .CenterY)
                return isInner ? attributes : attributes.horizontals(.Left, to: .Right)
            
            case .Center:
                return TG_LayoutAttributes(horizontal: .CenterX, referHorizontal: .CenterX, vertical: .CenterY, referVertical: .CenterY)
        }
    }
}

extension UIView {
    /**
     Fill subview
     
     - parameter referView: reference view
     - parameter insets:    edge insets
     
     - returns: constraints array
     */
    public func tg_Fill(referView: UIView, insets: UIEdgeInsets = UIEdgeInsetsZero) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(insets.left)-[subView]-\(insets.right)-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["subView" : self])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(insets.top)-[subView]-\(insets.bottom)-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["subView" : self])
        
        superview?.addConstraints(cons)
        
        return cons
    }

    /**
     Inner alignment referring to reference view
     
     - parameter type:      alignment type
     - parameter referView: reference view
     - parameter size:      view's size, will not set size if the value is nil
     - parameter offset:    offset value, CGPoint(x: 0, y: 0) by default
     
     - returns: constraints array
     */
    public func tg_AlignInner(type type: TG_AlignType, referView: UIView, size: CGSize?, offset: CGPoint = CGPointZero) -> [NSLayoutConstraint]  {
        
        return tg_AlignLayout(referView, attributes: type.layoutAttributes(true, isVertical: true), size: size, offset: offset)
    }

    /**
     Vertical alignment referring to reference view
     
     - parameter type:      alignment type
     - parameter referView: reference view
     - parameter size:      view's size, will not set size if the value is nil
     - parameter offset:    offset value, CGPoint(x: 0, y: 0) by default
     
     - returns: constraints array
     */
    public func tg_AlignVertical(type type: TG_AlignType, referView: UIView, size: CGSize?, offset: CGPoint = CGPointZero) -> [NSLayoutConstraint] {
        
        return tg_AlignLayout(referView, attributes: type.layoutAttributes(false, isVertical: true), size: size, offset: offset)
    }
    
    /**
     Horizontal alignment referring to reference view
     
     - param: type      alignment type
     - param: referView reference view
     - param: size      view's size, will not set size if the value is nil
     - param: offset    offset value, CGPoint(x: 0, y: 0) by default
     
     - returns: constraints array
     */
    public func tg_AlignHorizontal(type type: TG_AlignType, referView: UIView, size: CGSize?, offset: CGPoint = CGPointZero) -> [NSLayoutConstraint] {
        
        return tg_AlignLayout(referView, attributes: type.layoutAttributes(false, isVertical: false), size: size, offset: offset)
    }

    /**
     Tile widgets horizontally inside current view
    
     - param: views  subviews array
     - param: insets edge insets
    
     - returns: constraints array
     */
    public func tg_HorizontalTile(views: [UIView], insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        
        assert(!views.isEmpty, "Views should not be empty")
        
        var cons = [NSLayoutConstraint]()
        
        let firstView = views[0]
        firstView.tg_AlignInner(type: TG_AlignType.TopLeft, referView: self, size: nil, offset: CGPoint(x: insets.left, y: insets.top))
        cons.append(NSLayoutConstraint(item: firstView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -insets.bottom))
        
        // Add subsequent constraints
        var preView = firstView
        for i in 1..<views.count {
            let subView = views[i]
            cons += subView.tg_sizeConstraints(firstView)
            subView.tg_AlignHorizontal(type: TG_AlignType.TopRight, referView: preView, size: nil, offset: CGPoint(x: insets.right, y: 0))
            preView = subView
        }
        
        let lastView = views.last!
        cons.append(NSLayoutConstraint(item: lastView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -insets.right))
        
        addConstraints(cons)
        return cons
    }

    /**
     Tile widgets vertically inside current view
     
     - param: views  subviews array
     - param: insets edge insets
     
     - returns: constraints array
     */
    public func tg_VerticalTile(views: [UIView], insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        
        assert(!views.isEmpty, "Views should not be empty")
        
        var cons = [NSLayoutConstraint]()
        
        let firstView = views[0]
        firstView.tg_AlignInner(type: TG_AlignType.TopLeft, referView: self, size: nil, offset: CGPoint(x: insets.left, y: insets.top))
        cons.append(NSLayoutConstraint(item: firstView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -insets.right))
        
        // Add subsequent constraints
        var preView = firstView
        for i in 1..<views.count {
            let subView = views[i]
            cons += subView.tg_sizeConstraints(firstView)
            subView.tg_AlignVertical(type: TG_AlignType.BottomLeft, referView: preView, size: nil, offset: CGPoint(x: 0, y: insets.bottom))
            preView = subView
        }
        
        let lastView = views.last!
        cons.append(NSLayoutConstraint(item: lastView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -insets.bottom))
        
        addConstraints(cons)
        
        return cons
    }

    /**
     Search specified attribute's constraint frome constraints array
    
     - param: constraintsList constraint array
     - param: attribute       constraint attribute
    
     - returns: corresponding constraint
     */
    public func tg_Constraint(constraintsList: [NSLayoutConstraint], attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        for constraint in constraintsList {
            if constraint.firstItem as! NSObject == self && constraint.firstAttribute == attribute {
                return constraint
            }
        }
        
        return nil
    }
    
    // MARK: - Private functions
    /**
     Layout alignment referring to reference view
    
     - param: type      alignment type
     - param: referView reference view
     - param: size      view's size, will not set size if the value is nil
     - param: offset    offset value, CGPoint(x: 0, y: 0) by default
     
     - returns: constraints array
     */
    private func tg_AlignLayout(referView: UIView, attributes: TG_LayoutAttributes, size: CGSize?, offset: CGPoint) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        
        cons += tg_positionConstraints(referView, attributes: attributes, offset: offset)
        
        if size != nil {
            cons += tg_sizeConstraints(size!)
        }
        
        superview?.addConstraints(cons)
        
        return cons
    }
    

    /**
     Size constraints array
    
     - param: size view's size
    
     - returns: constraints array
     */
    private func tg_sizeConstraints(size: CGSize) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: size.width))
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: size.height))
        
        return cons
    }
    

    /**
     Size constraints array
    
     - param: referView reference view, same size as reference view
    
     - returns: constraint array
     */
    private func tg_sizeConstraints(referView: UIView) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: referView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: referView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
        
        return cons
    }
    
    /**
     Position constraints array
    
     - param: referView  reference view
     - param: attributes reference attributes
     - param: offset     offset value
    
     - returns: constraints array
     */
    private func tg_positionConstraints(referView: UIView, attributes: TG_LayoutAttributes, offset: CGPoint) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        
        cons.append(NSLayoutConstraint(item: self, attribute: attributes.horizontal, relatedBy: NSLayoutRelation.Equal, toItem: referView, attribute: attributes.referHorizontal, multiplier: 1.0, constant: offset.x))
        cons.append(NSLayoutConstraint(item: self, attribute: attributes.vertical, relatedBy: NSLayoutRelation.Equal, toItem: referView, attribute: attributes.referVertical, multiplier: 1.0, constant: offset.y))
        
        return cons
    }
}

///  Layout attributes
private final class TG_LayoutAttributes {
    var horizontal:         NSLayoutAttribute
    var referHorizontal:    NSLayoutAttribute
    var vertical:           NSLayoutAttribute
    var referVertical:      NSLayoutAttribute
    
    init() {
        horizontal = NSLayoutAttribute.Left
        referHorizontal = NSLayoutAttribute.Left
        vertical = NSLayoutAttribute.Top
        referVertical = NSLayoutAttribute.Top
    }
    
    init(horizontal: NSLayoutAttribute, referHorizontal: NSLayoutAttribute, vertical: NSLayoutAttribute, referVertical: NSLayoutAttribute) {
        
        self.horizontal = horizontal
        self.referHorizontal = referHorizontal
        self.vertical = vertical
        self.referVertical = referVertical
    }
    
    private func horizontals(from: NSLayoutAttribute, to: NSLayoutAttribute) -> Self {
        horizontal = from
        referHorizontal = to
        
        return self
    }
    
    private func verticals(from: NSLayoutAttribute, to: NSLayoutAttribute) -> Self {
        vertical = from
        referVertical = to
        
        return self
    }
}