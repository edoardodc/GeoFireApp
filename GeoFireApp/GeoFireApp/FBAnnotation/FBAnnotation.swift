import Foundation
import CoreLocation
import MapKit

open class FBAnnotation: NSObject {
    
    open var coordinate = CLLocationCoordinate2D()
    open var title: String?
}

extension FBAnnotation : MKAnnotation { }
