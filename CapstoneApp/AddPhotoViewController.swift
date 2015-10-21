//
//  AddPhotoViewController.swift
//  CapstoneApp
//
//  Created by Dimitrios Gravvanis on 8/10/15.
//  Copyright © 2015 Dimitrios Gravvanis. All rights reserved.
//

import UIKit
import Parse

// MARK: Class
class AddPhotoViewController: PageContentViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Properties
    var photos = [UIImage]()

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Image Picker Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            photos.append(image)
            
            let imageData = UIImageJPEGRepresentation(image, 0.5)
            let imageFile = PFFile(name:"image.jpeg", data:imageData!)
            
            SharingManager.sharedInstance.imageFiles.append(imageFile)
            
            imageFile.saveInBackgroundWithBlock({
                
                (succeeded: Bool, error: NSError?) -> Void in
                // Handle success or failure here ...
                
                    if succeeded {
                        
                        
                    }
                },
                
                progressBlock: {
                    
                    (percentDone: Int32) -> Void in
                    // Update your progress spinner here. percentDone will be between 0 and 100.
                    
                    
                    print(percentDone)
                }
            )
            
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Collection View Methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // Dequeue the reusable cell as custom cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        cell.imageView.image = photos[indexPath.row]
        
        return cell
    }
    
    // MARK: - Actions
    @IBAction func addPhotoButtonTouched(sender: UIButton) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
    }
}
