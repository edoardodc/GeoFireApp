import Foundation
import UIKit

struct FBBoundingBox {
	
    let x0, y0, xf, yf: CGFloat
}

extension FBBoundingBox {
	
	var xMid: CGFloat {
		return (xf + x0) / 2.0
	}

	var yMid: CGFloat {
		return (yf + y0) / 2.0
	}

	func intersects(box2: FBBoundingBox) -> Bool {
		return (x0 <= box2.xf && xf >= box2.x0 && y0 <= box2.yf && yf >= box2.y0)
	}
}


