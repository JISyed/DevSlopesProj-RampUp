//
//  RampPlacerViewController.swift
//  Ramp Up
//
//  Created by Jibran Syed on 10/29/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class RampPlacerViewController: UIViewController, ARSCNViewDelegate, UIPopoverPresentationControllerDelegate
{
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var stackOfControls: UIStackView!
    @IBOutlet weak var btnRotate: UIButton!
    @IBOutlet weak var btnUp: UIButton!
    @IBOutlet weak var btnDown: UIButton!
    
    
    var selectedRampName: String?
    var selectedRamp: SCNNode?
    
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false //true
        
        // Create a new scene
        let scene = SCNScene(named: "\(SCENE_ASSETS_DIRECTORY)mainScene.scn")!
        self.sceneView.autoenablesDefaultLighting = true
        
        // Set the scene to the view
        sceneView.scene = scene
        
        
        // Gestures for long pressed buttons
        let gesture1 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture:)))
        let gesture2 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture:)))
        let gesture3 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture:)))
        gesture1.minimumPressDuration = 0.1
        gesture2.minimumPressDuration = 0.1
        gesture3.minimumPressDuration = 0.1
        self.btnRotate.addGestureRecognizer(gesture1)
        self.btnUp.addGestureRecognizer(gesture2)
        self.btnDown.addGestureRecognizer(gesture3)
        
    }
    
    override func viewWillAppear(_ animated: Bool) 
    {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) 
    {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    override func didReceiveMemoryWarning() 
    {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    
    @objc
    func onLongPress(gesture: UILongPressGestureRecognizer)
    {
        if let ramp = self.selectedRamp
        {
            if gesture.state == .ended
            {
                ramp.removeAllActions()
            }
            else if gesture.state == .began
            {
                if gesture.view === self.btnRotate
                {
                    let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.08 * Double.pi), z: 0, duration: 0.1))
                    ramp.runAction(rotate)
                }
                else if gesture.view === self.btnUp
                {
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0.08, z: 0, duration: 0.1))
                    ramp.runAction(move)
                }
                else if gesture.view === self.btnDown
                {
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: -0.08, z: 0, duration: 0.1))
                    ramp.runAction(move)
                }
                else
                {
                    print("ERROR: RampPlacerVC.onLongPress: gesture's view is not one of the 3 supported buttons!")
                }
            }
        }
    }
    
    
    
    
    
    @IBAction func onRampButtonPressed(_ sender: UIButton) 
    {
        let rampPickerVC = RampPickerViewController(withSize: CGSize(width: 250, height: 500))
        rampPickerVC.rampPlacerVC = self
        rampPickerVC.modalPresentationStyle = .popover
        rampPickerVC.popoverPresentationController?.delegate = self
        present(rampPickerVC, animated: true, completion: nil)
        rampPickerVC.popoverPresentationController?.sourceView = sender
        rampPickerVC.popoverPresentationController?.sourceRect = sender.bounds
    }
    
    
    
    
    @IBAction func onRemoveButtonPressed(_ sender: Any) 
    {
        if let ramp = self.selectedRamp
        {
            ramp.removeFromParentNode()
            self.selectedRamp = nil
            self.selectedRampName = nil
            self.stackOfControls.isHidden = true
        }
    }
    
    
    
    
    
    func onRampSelected(_ rampName: String)
    {
        self.selectedRampName = rampName
    }
    
    
    
    func placeRamp(position: SCNVector3)
    {
        if let rampName = self.selectedRampName
        {
            let ramp = RampUtility.getRamp(withName: rampName, scale: 0.01, andPosition: position)
            self.selectedRamp = ramp
            self.sceneView.scene.rootNode.addChildNode(ramp)
            self.stackOfControls.isHidden = false
            self.selectedRampName = nil // Prevent making more ramps on accident
        }
        else
        {
            self.stackOfControls.isHidden = true
        }
        
    }
    
    
    // Touching the AR scene
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) 
    {
        guard let touch = touches.first else {return}
        let touchPosition = touch.location(in: self.sceneView)
        
        // First check if a scene kit object was selected
        let sceneHitResults = sceneView.hitTest(touchPosition, options: [:])     // Ray collison test with stuff in the scene
        
        // If a virtual object was touched
        if sceneHitResults.count > 0
        {
            let node = sceneHitResults[0].node
            self.selectedRampName = nil
            self.selectedRamp = node    // Hopefully the node was a ramp of some kind
            self.stackOfControls.isHidden = false
        }
        else // If the real world was touched instead
        {
            // Checking AR real-world anchors
            
            let realWorldHitResults = self.sceneView.hitTest(touchPosition, types: [.featurePoint])
            
            guard let hitFeature = realWorldHitResults.last else {return}
            
            // Get position in world space for where touch hits the scene world
            let hitTransformMatrix = SCNMatrix4(hitFeature.worldTransform)
            let hitPosition = SCNVector3Make(hitTransformMatrix.m41, hitTransformMatrix.m42, hitTransformMatrix.m43)
            
            self.placeRamp(position: hitPosition)
        }
        
    }
    
    
    
    // AR Scene stuff
    
    func session(_ session: ARSession, didFailWithError error: Error) 
    {
        // Present an error message to the user
        
    }
    
    
    func sessionWasInterrupted(_ session: ARSession) 
    {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    
    func sessionInterruptionEnded(_ session: ARSession) 
    {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    
    
    
    // Popover stuff
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle 
    {
        return .none
    }
    
    
}





