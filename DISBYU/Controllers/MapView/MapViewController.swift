//
//  ViewController.swift
//  DISBYU
//
//  Created by Trevor Schmidt on 11/17/20.
//

import UIKit
import MapKit
import Cosmos
import TinyConstraints
import FloatingPanel
import FirebaseDatabase

//THIS IS THE MAIN SCREEN
class MapViewController: UIViewController {
    // Database references
    private let rootRef = Database.database().reference()
    private let buildingsRef = Database.database().reference().child("buildings")
    private let bathroomsInfoRef = Database.database().reference().child("bathroomsInfo")
    
    // It has the map view
    @IBOutlet weak var mapView: MKMapView!
    // And a bathroom tableviewcontroller, which is the movable table view
    private var contentViewController: BathroomTableViewController?
    
    // The top has the title label, and the profile and leadership buttons
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var leaderButton: UIBarButtonItem!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    
    // Set once a building is selected
    var currentBuildingID = ""
    
    // List of bathrooms currently selected
    var bathroomsArray = [[Bathroom]]()
    
    // loading is true to start, will set to false once everything is loaded
    var loading = true
    // Center change is true, which affects the tableview
    var centerChange = true

    // Location manager is how our app will comunicate with the location settings
    // of the phone
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Globals.userID != "0" {
            rootRef.child("users").child(Globals.userID).child("username").observeSingleEvent(of: .value, with: { (snapshot) in
                Globals.updateUsername(newUsername: snapshot.value as! String)
            })
        }

        navBarTitle.title = "BYU Bathrooms"
        leaderButton.isEnabled = false
        leaderButton.tintColor = UIColor.clear

        mapView.delegate = self
        mapView.showsUserLocation = true

        // Set up floating tableview
        guard let contentVC = storyboard?.instantiateViewController(identifier: "bathroomTableViewController") as? BathroomTableViewController else { return }
        contentViewController = contentVC
        contentViewController!.loadView() // idk why this is neccessary but it is
        contentViewController?.tableView.delegate = self
        contentViewController?.tableView.dataSource = self
        contentViewController?.tableView.contentInsetAdjustmentBehavior = .never
        
        let fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.set(contentViewController: contentViewController)
        fpc.addPanel(toParent: self)
        
        fpc.track(scrollView: contentVC.tableView)
        
        // Start the program basically
        checkLocationServices()
        
        // Then add Buildings
        addAnnotationsAndSelectNearestBuilding()
    }
    
    // Location functions
    private func checkLocationServices() {
        // If location services are enables device wide...
        if CLLocationManager.locationServicesEnabled() {
            // Set up location stuff
            setUpLocationManager()
            
            // Proceed the program to this function
            checkLocationAuthorization()
        } else { // This happens when the user turns off location device wide in the settings
            // TODO: Show alert to user to turn on location
        }
    }
    private func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    // Checks to ensure we have the correct location authorization
    private func checkLocationAuthorization() {
        switch  CLLocationManager.authorizationStatus(){
            case .authorizedWhenInUse:
                // This is what we want
                // Proceed the program
                break
            case .authorizedAlways:
                // Don't really care for this
                // We will never ask for it, so there's no way the user can have this option
                // I just put this case in here so I can use this funct in other apps
                break
            case .notDetermined:
                // They have not authorized location, therefore we request
                locationManager.requestWhenInUseAuthorization()
                break
            case .denied:
                // Happens when the user has said that they do not want to share location with the app
                locationManager.requestWhenInUseAuthorization()
                break
            case .restricted:
                // Happens when there are content restrictions on the phone, Such as parent restrictions or something, May not be able to change it
                break
            default:
                print("Default in check location services")
                break
            }
    }
    
    // Add all the annotations FINISHED
    private func addAnnotationsAndSelectNearestBuilding() {
        
        rootRef.child("buildings").observeSingleEvent(of: .value) { (snapshot) in
            let buildings = snapshot.value as! [String : [String : NSObject]]

            // Create list of annotations
            var annotations: [MKPointAnnotation] = []
            
            if let userLocation = self.locationManager.location?.coordinate {
                //Grab user's location as a point
                let userPoint: MKMapPoint = MKMapPoint(userLocation)
                var closestDist: CLLocationDistance = CLLocationDistanceMax
                var closestBuildingAnnotation = MKPointAnnotation()
                
                // for each building
                for buildingKey in buildings.keys {
                    
                    // create an annotation
                    let newBuilding = MKPointAnnotation()
                    
                    // add in the info
                    newBuilding.title = buildingKey
                    newBuilding.subtitle = (buildings[buildingKey]?["fullname"] as! String)
                    newBuilding.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(buildings[buildingKey]?["latitude"] as! Double), longitude: CLLocationDegrees(buildings[buildingKey]?["longitude"] as! Double))
                    
                    // and add it to the list
                    annotations.append(newBuilding)
                    
                    //Check distances
                    // Get the distance between the building and our user
                    let distance: CLLocationDistance = userPoint.distance(to: MKMapPoint(newBuilding.coordinate))
                    // If this distance is closer than normal
                    if distance < closestDist {
                        // Update CLLocationDistance
                        closestDist = distance
                        // Update closest annotation
                        closestBuildingAnnotation = newBuilding
                        // Update self attributes
                        self.currentBuildingID = newBuilding.title!
                        self.contentViewController?.currentBuildingID = newBuilding.title!
                    }
                }
                
                // Then add all the annotations to the map
                for annotation in annotations {
                    self.mapView.addAnnotation(annotation)
                    #if APPCLIP
                    if annotation.title == Globals.buildingID {
                        closestBuildingAnnotation = annotation
                    }
                    #endif
                }

                // And select the closest building
                self.mapView.selectAnnotation(closestBuildingAnnotation, animated: true)
                
            } else { // if no userlocation
                
                var closestBuildingAnnotation = MKPointAnnotation()
                
                // for each building
                for buildingKey in buildings.keys {
                    
                    // create an annotation
                    let newBuilding = MKPointAnnotation()
                    
                    // add in the info
                    newBuilding.title = buildingKey
                    newBuilding.subtitle = (buildings[buildingKey]?["fullname"] as! String)
                    newBuilding.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(buildings[buildingKey]?["latitude"] as! Double), longitude: CLLocationDegrees(buildings[buildingKey]?["longitude"] as! Double))
                    
                    // and add it to the list
                    annotations.append(newBuilding)
                
                }
                
                // Then add all the annotations to the map
                for annotation in annotations {
                    self.mapView.addAnnotation(annotation)
                    #if APPCLIP
                    if annotation.title == Globals.buildingID {
                        closestBuildingAnnotation = annotation
                    }
                    #endif
                }

                // And select the first building
                #if APPCLIP
                self.mapView.selectAnnotation(closestBuildingAnnotation, animated: true)
                #else
                self.mapView.selectAnnotation(annotations[0], animated: true)
                #endif
            }
        }
    }
    
    func grabBathroomsInBuilding(buildingID: String) {
        bathroomsInfoRef.child(buildingID).observe(.value) { (snapshot) in
            
            
            // Reset the bathrooms array
            var bathrooms = [Bathroom]()
            
            // make sure we get a list of bathrooms from that building
            if let bathroomsDict = snapshot.value as? [String:Any] {
                
                // for each bathroom in that building
                for key in bathroomsDict.keys {
                    
                    // create a bathroom
                    var bathroomName: String = ""
                    let bathroomNumber: String = key
                    var floorNumber: Int = 0
                    var numReviews: Int = 0
                    var avgRating: Float = 0.0
                    
                    // we look at each piece of info
                    if let infoDict = bathroomsDict[key] as? [String:Any] {
                        
                        // for each piece of info of that bathroom
                        for infoKey in infoDict.keys {
                            // the name
                            if infoKey == "name" {
                                bathroomName = infoDict[infoKey] as! String
                            }
                            // the floor
                            else if infoKey == "floor" {
                                floorNumber = infoDict[infoKey] as! Int
                            }
                            // the ratings, if there is any lol
                            else if infoKey == "ratings" {
                                // view all the ratings
                                if let ratingsDict = infoDict[infoKey] as? [String:Int] {
                                    var totalRatings = 0
                                    // for each rating of that bathroom
                                    for ratingsKey in ratingsDict.keys {
                                        numReviews += 1 // find the count
                                        totalRatings += ratingsDict[ratingsKey]!
                                    }
                                    // and the average
                                    avgRating = Float(Float(totalRatings) / Float(numReviews))
                                }
                            }
                        }
                    }

                    // Create a bathroom
                    let newBathroom = Bathroom(buildingID: buildingID, bathroomName: bathroomName, bathroomNumber: bathroomNumber, floorNumber: floorNumber, numReviews: numReviews, avgRating: avgRating)
                    
                    // add it to our list
                    bathrooms.append(newBathroom)
                } // end run through of bathrooms from snapshot
                
                // sort the bathrooms based on floor
                bathrooms = bathrooms.sorted(by: {$0.floorNumber < $1.floorNumber})
                
                //reset double array
                self.bathroomsArray = [[Bathroom]]()
                
                // get first bathroom
                var previousBathroom = bathrooms[0]
                // create a current array to hold all bathrooms of the same level
                var currentFloorBathroomsArray = [Bathroom]()
                // and add the first bathroom to that array
                currentFloorBathroomsArray.append(previousBathroom)
                // for all other bathrooms, if there are any
                if bathrooms.count > 1 {
                    for (i, bathroom) in bathrooms.enumerated() {
                        if i != 0 {
                            // if the next bathroom's floor is equal to the last
                            if bathroom.floorNumber == previousBathroom.floorNumber {
                                // then append it to the current floor
                                currentFloorBathroomsArray.append(bathroom)
                            } else { // else, if new floor
                                currentFloorBathroomsArray = currentFloorBathroomsArray.sorted(by: {$0.bathroomNumber < $1.bathroomNumber})
                                
                                // append the previous floor to the 2d array
                                self.bathroomsArray.append(currentFloorBathroomsArray)
                                // and reset the current floor
                                currentFloorBathroomsArray = [bathroom]
                            }
                            // then move on to the next bathroom
                            previousBathroom = bathroom
                        }
                    }
                }
                // at the end, append the last floor
                self.bathroomsArray.append(currentFloorBathroomsArray)
                // set the content view controller's bathroom array to this one
                self.contentViewController?.bathroomsArray = self.bathroomsArray
                
                // everything is done, so reload the data.
                self.loading = false
                self.contentViewController?.tableView.reloadData()
            } // end of if we actually get info
        } // end of call to db
    } // end grabBathroomsInBuilding
    
    // LEADERSHIP BUTTON PRESSED - not fully neccessary
    @IBAction func leaderButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showLeaderBoard", sender: self)
    }
    
    // PROFILE BUTTON PRESSED
    @IBAction func profileButtonPressed(_ sender: Any) {
        if Globals.userID == "0" {
            self.performSegue(withIdentifier: "showLogin", sender: self)
        } else {
            print("button pressed")
            self.performSegue(withIdentifier: "showProfile", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        // Get info ready for reviewViewController
        case "showLogin":
            print("Prepare for showLogin")
        case "showProfile":
            print("preapre for showProfile")
            let userViewController = segue.destination as! UserViewController
            userViewController.userID = Globals.userID
            userViewController.username = Globals.username
            userViewController.isUser = true
        case "showReview":
            print("Prepare for showReview")
        case "loginFromBathroom":
            print("Prepare for showlogingFromBathron")
        default:
            preconditionFailure("Unexpected segue identifier in bathroomViewController.")
        }
    }
    
    // COMING BACK TO THIS VIEW
    @IBAction func unwindToMapView(_ segue: UIStoryboardSegue) {}
    
} // End of class of mapViewController

// Delagate for Location Manager Delegate
extension MapViewController: CLLocationManagerDelegate {
    // User changes location authorization, kinda never used
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

// Delegate for MapView
extension MapViewController: MKMapViewDelegate {
    
    // Event for when an annotation is selected
    // BUILDING SELECTED
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // if its the user's location, then don't do anything
        if view.annotation is MKUserLocation { return }
        
        // Grab all the bathrooms, also reloads the table view
        grabBathroomsInBuilding(buildingID: (view.annotation?.title)!!)
       
        // update point to zoom into, based on if the tableview is extended or not
        var center = view.annotation!.coordinate
        if centerChange {
            center.latitude -= 0.001
        } else {
            center.latitude -= 0.0003
        }
        
        // Zoom into the new region of where you've selected
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: true)
    }
}

// Delegate for FloatingPanelController
extension MapViewController: FloatingPanelControllerDelegate {
    func floatingPanelWillEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
        // This is used when selecting the region on the map
        switch targetState.pointee {
        case .full:
            self.centerChange = true
        case .half:
            self.centerChange = true
        default:
            self.centerChange = false
            break
        }
    }
}

extension MapViewController: UITableViewDelegate {
    // if a cell is selected, kinda boring
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.contentViewController?.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MapViewController: UITableViewDataSource {
    // Number of sections (aka. floors)
    func numberOfSections(in tableView: UITableView) -> Int {
        if loading {
            return 0
        } else {
            return bathroomsArray.count
        }
    }

    // Title for each floor
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if loading {
            return "Loading..."
        } else {
            return "Floor: " + String(bathroomsArray[section][0].floorNumber)
        }
    }
    
    // Number of rows for each floor
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loading {
            return 0
        } else {
            return bathroomsArray[section].count
        }

    }
    
    // The actual tableCell stuff
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BathroomCell", for: indexPath) as! BathroomCell
        
        cell.bathroomStarsView.settings.fillMode = .precise
        
        if loading {
            cell.bathroomNameLabel.text = "Loading"
            cell.bathroomNumberLabel.text = "Loading"
            cell.bathroomRatingsLabel.text = "Loading"
            cell.bathroomStarsView.rating = 5.0
            
        } else {
            cell.bathroomNameLabel.text = bathroomsArray[indexPath.section][indexPath.row].bathroomName
            cell.bathroomNumberLabel.text = bathroomsArray[indexPath.section][indexPath.row].bathroomNumber
            if bathroomsArray[indexPath.section][indexPath.row].numReviews == 1 {
                cell.bathroomRatingsLabel.text = String(bathroomsArray[indexPath.section][indexPath.row].numReviews) + " Rating"
            } else {
                cell.bathroomRatingsLabel.text = String(bathroomsArray[indexPath.section][indexPath.row].numReviews) + " Ratings"
            }
            cell.bathroomStarsView.rating = Double(bathroomsArray[indexPath.section][indexPath.row].avgRating)
        }
        return cell
    }
}

