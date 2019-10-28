//  Created by Edoardo de Cal on 10/28/19.
//  Copyright © 2019 Edoardo de Cal. All rights reserved.
//

import Foundation
import MapKit

class Fountain: NSObject, MKAnnotation {

    var nameStreet: String?
    var nameCity: String?
    var nameRegion: String?
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }

    
}
