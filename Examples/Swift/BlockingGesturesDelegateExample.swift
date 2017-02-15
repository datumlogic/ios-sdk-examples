import Mapbox

@objc(BlockingGesturesDelegateExample_Swift)

class BlockingGesturesDelegateExample_Swift: UIViewController, MGLMapViewDelegate {
    
    private var colorado: MGLCoordinateBounds!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isRotateEnabled = false
        mapView.minimumZoomLevel = 10
        mapView.delegate = self
        
        // Denver, Colorado
        let center = CLLocationCoordinate2D(latitude: 39.748947, longitude: -104.995882)
        
        // Starting point.
        mapView.setCenter(center, zoomLevel: 10, direction: 0, animated: false)
        
        // Colorado's bounds
        let ne = CLLocationCoordinate2D(latitude: 40.989329, longitude: -102.062592)
        let sw = CLLocationCoordinate2D(latitude: 36.986207, longitude: -109.049896)
        colorado = MGLCoordinateBounds(sw: sw, ne: ne)
        
        view.addSubview(mapView)

    }
    
    func mapView(_ mapView: MGLMapView, shouldChangeFrom oldCamera: MGLMapCamera, to newCamera: MGLMapCamera) -> Bool {
        
        // Get current coordinates
        let newCameraCenter: CLLocationCoordinate2D = newCamera.centerCoordinate
        let camera = mapView.camera

        // Get new bounds
        mapView.camera = newCamera
        let newVisibleCoordinates = mapView.visibleCoordinateBounds
        
        // Revert camera update
        mapView.camera = camera

        // Test if the new camera center point and boundaries are inside colorado
        let inside: Bool = MGLCoordinateInCoordinateBounds(newCameraCenter, self.colorado)
        let intersects: Bool = MGLCoordinateInCoordinateBounds(newVisibleCoordinates.ne, self.colorado) && MGLCoordinateInCoordinateBounds(newVisibleCoordinates.sw, self.colorado)
        
        return inside && intersects

    }
}
