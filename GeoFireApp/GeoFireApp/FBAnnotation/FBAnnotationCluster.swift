import Foundation
import MapKit

open class FBAnnotationCluster: NSObject {
    
    open var coordinate = CLLocationCoordinate2D()
    open var title: String?
    open var subtitle: String?
    
    open var annotations: [MKAnnotation] = []
}

extension FBAnnotationCluster : MKAnnotation { }
