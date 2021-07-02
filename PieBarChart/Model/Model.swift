// MIT License
//
// Copyright (c) 2021 Ian Cooper
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

public struct ChartData {
    ///data Name
    public var names:[String]
    {
        willSet{ //will set the count for our ChartData
            self.count = newValue.count
        }
    }
    ///data
    public var data:[Double]
    ///colors for our views
    public var colors:[UIColor]
    ///count of entries
    public var count:Int
    
    public init() {
        self.names = [];self.data = [];self.colors = [];self.count = 0
    }
}

extension ChartData:Comparable, Hashable, CustomDebugStringConvertible{
    
    public static func < (lhs: ChartData, rhs: ChartData) -> Bool {
        return lhs.names == rhs.names && lhs.data == rhs.data
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(count)
    }
    
    public var debugDescription: String {
        return "count: \(count)\n, names: \(names)\n,data: \(data)"
    }
    
    func entry(for index:Int) -> (name:String,data: Double,color: UIColor)?{
        guard index < count && index >= 0 else {return nil}
        return (names[index], data[index], colors[index])
    }
    
    public subscript(position: Int) -> (name:String,data: Double,color: UIColor)? {
        guard position < count && position >= 0 else {return nil}
        return (names[position], data[position], colors[position])
    }
}


func bgLightOrDark() -> UIColor{
    if UITraitCollection.current.userInterfaceStyle == .dark{
        return UIColor.darkGray.darker.darker
    }else{
        return UIColor.systemBackground
    }
}

func LightOrDark() -> UIColor{
    if UITraitCollection.current.userInterfaceStyle == .dark{
        return UIColor.white
    }else{
        return UIColor.black
    }
}

extension UIColor{

    var darker: UIColor {

    var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0

        guard self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) else {
            print("** some problem demuxing the color")
            return .gray
        }

        let nudged = b * 0.6

        return UIColor(hue: h, saturation: s, brightness: nudged, alpha: a)
    }
    
    var lighter: UIColor {

    var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0

        guard self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) else {
            print("** some problem demuxing the color")
            return .gray
        }

        let nudged = b * 1.6

        return UIColor(hue: h, saturation: s, brightness: nudged, alpha: a)
    }
}


// MARK: - Font
extension UIFont {

    public enum Custom: String {
        case AppleSDGothicNeo_Bold = "AppleSDGothicNeo-Bold"
        case AppleSDGothicNeo_Light = "AppleSDGothicNeo-Light"
        case AppleSDGothicNeo_Medium = "AppleSDGothicNeo-Medium"
        case AppleSDGothicNeo_Regular = "AppleSDGothicNeo-Regular"
        case AppleSDGothicNeo_SemiBold = "AppleSDGothicNeo_SemiBold"
        case AppleSDGothicNeo_Thin = "AppleSDGothicNeo-Thin"
        case AppleSDGothicNeo_UltraLight = "AppleSDGothicNeo-UltraLight"
    }

    static func customFont(type: Custom = .AppleSDGothicNeo_Regular, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: "\(type.rawValue)", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
