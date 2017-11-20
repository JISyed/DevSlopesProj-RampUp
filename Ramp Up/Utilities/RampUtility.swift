//
//  Ramp.swift
//  Ramp Up
//
//  Created by Jibran Syed on 10/29/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import Foundation
import SceneKit


class RampUtility
{
    
    class func getRamp(withName name: String, scale scaleFactor: Float, andPosition position: SCNVector3) ->SCNNode
    {
        // Get a model from a scn file:
        // - Open the scn file as a SCNScene
        // - Find a SCNNode in the scene of a specified name (search recursively down from the scene's invisible root node
        let obj = SCNScene(named: "\(SCENE_ASSETS_DIRECTORY)\(name).scn") 
        let node = obj?.rootNode.childNode(withName: "\(name)", recursively: true)
        node?.scale = SCNVector3Make(scaleFactor, scaleFactor, scaleFactor)
        node?.position = position
        
        return node!
    }
    
    class func getPipe(withScale scaleFactor: Float, andPosition position: SCNVector3) -> SCNNode
    {
        let pipeObj = SCNScene(named: "\(SCENE_ASSETS_DIRECTORY)pipe.scn") 
        let pipeNode = pipeObj?.rootNode.childNode(withName: "pipe", recursively: true)
        pipeNode?.scale = SCNVector3Make(scaleFactor, scaleFactor, scaleFactor)
        pipeNode?.position = position
        
        return pipeNode!
    }
    
    
    class func getPyramid(withScale scaleFactor: Float, andPosition position: SCNVector3) -> SCNNode 
    {
        let pyramidObj = SCNScene(named: "\(SCENE_ASSETS_DIRECTORY)pyramid.scn") 
        let pyramidNode = pyramidObj?.rootNode.childNode(withName: "pyramid", recursively: true)
        pyramidNode?.scale = SCNVector3Make(scaleFactor, scaleFactor, scaleFactor)
        pyramidNode?.position = position
        
        return pyramidNode!
    }
    
    
    class func getQuarter(withScale scaleFactor: Float, andPosition position: SCNVector3) -> SCNNode 
    {
        let quarterObj = SCNScene(named: "\(SCENE_ASSETS_DIRECTORY)quarter.scn") 
        let quarterNode = quarterObj?.rootNode.childNode(withName: "quarter", recursively: true)
        quarterNode?.scale = SCNVector3Make(scaleFactor, scaleFactor, scaleFactor)
        quarterNode?.position = position
        
        return quarterNode!
    }
    
    
    class func startRotation(node: SCNNode)
    {
        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.01 * Double.pi), z: 0, duration: 0.1))
        node.runAction(rotate)
    }
    
}
