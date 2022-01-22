//
//  ExpandableText.swift
//  GistTeste
//  Sourcec from  https://github.com/NuPlay/ExpandableText?ref=iosexample.com
//  Created by Paulo H.M. on 22/01/22.
//

import UIKit

import SwiftUI

public struct ExpandableText: View {
    var text : String
    
    var font: Font = .body
    var lineLimit : Int = 3
    var foregroundColor : Color = .primary
    
    var expandButtonText : String = "Mostra"
    var expandButtonColor : Color = .blue
    
    var uiFont: UIFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
    @State private var expand : Bool = false
    @State private var truncated : Bool = false
    @State private var size : CGFloat = 0
    
    
    public init(text: String) {
        self.text = text
    }
    public var body: some View {
        ZStack(alignment: .bottomTrailing){
            Text(text)
                .font(font)
                .foregroundColor(foregroundColor)
                .lineLimit(expand == true ? nil : lineLimit)
                .mask(
                    VStack(spacing: 0){
                        Rectangle()
                            .foregroundColor(.black)
                        
                        HStack(spacing: 0){
                            Rectangle()
                                .foregroundColor(.black)
                            if !expand && truncated{
                                HStack(alignment: .bottom,spacing: 0){
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            Gradient.Stop(color: .black, location: 0),
                                            Gradient.Stop(color: .clear, location: 0.8)]),
                                        startPoint: .leading,
                                        endPoint: .trailing)
                                        .frame(width: 32, height: expandButtonText.heightOfString(usingFont: uiFont))
                                    
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: expandButtonText.widthOfString(usingFont: uiFont), alignment: .center)
                                }
                            }
                        }
                        .frame(height: expandButtonText.heightOfString(usingFont: uiFont))
                    }
                )
            
            if truncated && !expand {
                Button(action: {
                    self.expand = true
                }, label: {
                    Text(expandButtonText)
                        .font(font)
                        .foregroundColor(expandButtonColor)
                })
            }
        }
        .background(
            Text(text)
                .lineLimit(lineLimit)
                .background(GeometryReader { geo in
                    Color.clear.onAppear() {
                        let size = CGSize(width: geo.size.width, height: .greatestFiniteMagnitude)
                        
                        let attributes:[NSAttributedString.Key:Any] = [NSAttributedString.Key.font: uiFont]
                        let attributedText = NSAttributedString(string: text, attributes: attributes)
                        
                        let textSize = attributedText.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
                        
                        if textSize.size.height > geo.size.height {
                            truncated = true
                            
                            self.size = textSize.size.height
                        }
                    }
                })
                .hidden()
        )
    }
}


extension ExpandableText {
    public func font(_ font: Font) -> ExpandableText {
        var result = self
        
        if #available(iOS 14.0, *) {
            switch font {
            case .largeTitle:
                result.uiFont = UIFont.preferredFont(forTextStyle: .largeTitle)
            case .title:
                result.uiFont = UIFont.preferredFont(forTextStyle: .title1)
            case .title2:
                result.uiFont = UIFont.preferredFont(forTextStyle: .title2)
            case .title3:
                result.uiFont = UIFont.preferredFont(forTextStyle: .title3)
            case .headline:
                result.uiFont = UIFont.preferredFont(forTextStyle: .headline)
            case .subheadline:
                result.uiFont = UIFont.preferredFont(forTextStyle: .subheadline)
            case .callout:
                result.uiFont = UIFont.preferredFont(forTextStyle: .callout)
            case .caption:
                result.uiFont = UIFont.preferredFont(forTextStyle: .caption1)
            case .caption2:
                result.uiFont = UIFont.preferredFont(forTextStyle: .caption2)
            case .footnote:
                result.uiFont = UIFont.preferredFont(forTextStyle: .footnote)
            case .body:
                result.uiFont = UIFont.preferredFont(forTextStyle: .body)
            default:
                result.uiFont = UIFont.preferredFont(forTextStyle: .body)
            }
        } else {
            switch font {
            case .largeTitle:
                result.uiFont = UIFont.preferredFont(forTextStyle: .largeTitle)
            case .title:
                result.uiFont = UIFont.preferredFont(forTextStyle: .title1)
            case .headline:
                result.uiFont = UIFont.preferredFont(forTextStyle: .headline)
            case .subheadline:
                result.uiFont = UIFont.preferredFont(forTextStyle: .subheadline)
            case .callout:
                result.uiFont = UIFont.preferredFont(forTextStyle: .callout)
            case .caption:
                result.uiFont = UIFont.preferredFont(forTextStyle: .caption1)
            case .footnote:
                result.uiFont = UIFont.preferredFont(forTextStyle: .footnote)
            case .body:
                result.uiFont = UIFont.preferredFont(forTextStyle: .body)
            default:
                result.uiFont = UIFont.preferredFont(forTextStyle: .body)
            }
        }
        result.font = font
        
        return result
    }
    public func lineLimit(_ lineLimit: Int) -> ExpandableText {
        var result = self
        
        result.lineLimit = lineLimit
        return result
    }
    
    public func foregroundColor(_ color: Color) -> ExpandableText {
        var result = self
        
        result.foregroundColor = color
        return result
    }
    
    public func expandButtonText(_ text: String) -> ExpandableText {
        var result = self
        
        result.expandButtonText = text
        return result
    }
    public func expandButtonColor(_ color: Color) -> ExpandableText {
        var result = self
        
        result.expandButtonColor = color
        return result
    }
}

extension String {
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
