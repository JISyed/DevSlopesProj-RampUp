//
//  RampPickerViewController.swift
//  Ramp Up
//
//  Created by Jibran Syed on 10/29/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit
import SceneKit

class RampPickerViewController: UIViewController 
{
    var sceneView: SCNView!
    var size: CGSize!
    weak var rampPlacerVC: RampPlacerViewController!    // Weak reference to prevent unneeded retain cycle
    
    
    
    init(withSize size: CGSize) 
    {
        super.init(nibName: nil, bundle: nil)
        
        self.size = size
    }
    
    
    required init?(coder aDecoder: NSCoder) 
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.frame = CGRect(origin: CGPoint.zero, size: self.size)
        self.sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        self.view.insertSubview(self.sceneView, at: 0)
        self.preferredContentSize = self.size
        self.view.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.view.layer.borderWidth = 3.0
        
        
        let scene = SCNScene(named: "\(SCENE_ASSETS_DIRECTORY)rampPicker.scn")!
        self.sceneView.scene = scene
        
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene.rootNode.camera = camera
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.sceneView.addGestureRecognizer(tapGesture)
        
        
        let pipe = RampUtility.getPipe(withScale: 0.0022, andPosition: SCNVector3(-1, 0.7, -1))
        RampUtility.startRotation(node: pipe)
        scene.rootNode.addChildNode(pipe)
        
        let pyramid = RampUtility.getPyramid(withScale: 0.0058, andPosition: SCNVector3(-1, -0.45, -1))
        RampUtility.startRotation(node: pyramid)
        scene.rootNode.addChildNode(pyramid)
        
        let quarter = RampUtility.getQuarter(withScale: 0.0058, andPosition: SCNVector3(-1, -2.2, -1))
        RampUtility.startRotation(node: quarter)
        scene.rootNode.addChildNode(quarter)
    }
    
    
    @objc
    func handleTap(_ gestureRecognizer: UIGestureRecognizer)
    {
        let p = gestureRecognizer.location(in: self.sceneView)
        let hitResults = sceneView.hitTest(p, options: [:])     // Ray collison test with stuff in the scene
        
        if hitResults.count > 0
        {
            let node = hitResults[0].node
            self.rampPlacerVC.onRampSelected(node.name!)
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
}


