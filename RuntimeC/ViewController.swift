//
//  ViewController.swift
//  RuntimeC
//
//  Created by Nikita Skrypchenko on 06.09.2022.
//
import SceneKit
import UIKit


class ViewController: UIViewController {
    
    lazy var sceneView: SCNView = {
        SCNView(frame: self.view.frame)
    }()
    
    var sphereNode: SCNNode!
    var previousPanPoint: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(sceneView)
        
        let obj = CatInBox.getUser()!
        getNSObjectFromAnyObject(obj, sampleClassName: "CatInBox") { url in
            self.imageFromUrl(url: url) { image in
                self.makeSphere(with: image)
            }
            
        }
    }
    

    //MARK: Step 1
    func getNSObjectFromAnyObject(_ obj: AnyObject, sampleClassName: String, closure: @escaping(URL)->()){
        
        //MARK: printing
        print(obj)
        
        
        
        //
        //MARK: objc_getClass
        if let sampleClass = objc_getClass(sampleClassName) as? AnyClass {
            
            if let classNSObject = obj as? NSObject {
                
                //MARK: isKind
                if classNSObject.isKind(of: sampleClass) {
                    //MARK: Step 2 Unwrapping class instance variables
                    
                    let object = classNSObject
                    let currectClass = type(of: object)
//                    let ivarName = "_name"
                    let imagePropertyName = "image"
                    let funName = "getAdditionalData"
                    
                    
                    inspect(sampleClass)

                    
                    
                    //what is IVAR - InstanceVariable
                    let ivarName = "_name"
                    if let ivar = class_getInstanceVariable(currectClass, ivarName) {
                        if let internalName = object_getIvar(classNSObject, ivar) as? NSObject {
                            print("Cat name in the box is: \(internalName)") //Print the name
                        }
                    }
                    
                    let ivarssName = "_image"
                    if let ivar = class_getInstanceVariable(currectClass, ivarName) {
                        if let internalName = object_getIvar(classNSObject, ivar) as? NSObject {
                            print("Cat name in the box is: \(internalName)") //Print the name
                        }
                    }
                    
                    
                    
                
                    // Property
                    if let property = ObjectiveC.class_getProperty(sampleClass, imagePropertyName) {
                        if let typeNameCString = property_copyAttributeValue(property, "T") {
                            let typeName = String(cString: typeNameCString)
                            if typeName == "@\"Image\"" {
                                let getter: Selector
                                if let getterName = property_copyAttributeValue(property, "G") {
                                    getter = sel_getUid(getterName)
                                } else {
                                    getter = NSSelectorFromString(imagePropertyName)
                                }
                                
                                if classNSObject.responds(to: getter) {
                                    let methodImplementation = class_getMethodImplementation(sampleClass, getter)
                                    let getterSignature = (@convention(c)(NSObject?, Selector) -> Any).self
                                    let getterMethod = unsafeBitCast(methodImplementation, to: getterSignature)

                                    
                                    
                                    
                                    // MARK: Swizzling
                                    // getData invokation
                                    let getDataSelector = NSSelectorFromString(funName)
                                    let getDataMethod = ObjectiveC.class_getClassMethod(sampleClass, getDataSelector)!
                                    let getDataImp = method_getImplementation(getDataMethod)
                                    
                                    // swizzling helper
                                    let f: (NSObject?, Selector) -> Any = {ns, sel in
                                        let val = unsafeBitCast(getDataImp, to: getterSignature)(classNSObject, getDataSelector)
                                        return "\(val)and catssss"
                                    }

                                    //new implementation
                                    let myIMP = imp_implementationWithBlock(
                                        unsafeBitCast(
                                            f as (@convention(block) (NSObject?, Selector) -> Any),
                                            to: AnyObject.self
                                        )
                                    )
                                    // swizzle
                                    method_setImplementation(getDataMethod, myIMP)
                                    
                                    let getterMethodS = unsafeBitCast(myIMP, to: getterSignature)
                                    print(getterMethodS(classNSObject, getDataSelector))
                                    // MARK: swizzling end
                                    
                                    
                                    

                                    let value = getterMethod(classNSObject, getter)
                                    print(value)
                                    switch value {
                                    case let obj as NSObject:
                                        let optional = obj as? NSObject
                                        if let imageNSObj = optional {
                                            let imageClassName = "Image"
                                            if let imageClass = objc_getClass(imageClassName) as? AnyClass {
                                                if let imageNSObj = obj as? NSObject {
                                                    if imageNSObj.isKind(of: imageClass) {
                                                        
                                                        let imageIvarName = "imageURL"
                                                        if let imageURLIVar = class_getInstanceVariable(imageClass, imageIvarName) {
                                                        
                                                            if let imageURL = object_getIvar(imageNSObj, imageURLIVar) as? NSURL? {
                                                                closure(imageURL! as URL)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        } else {
                                            break
                                        }
                                    default:
                                        break
                                    }
                                }
                            }
                            free(typeNameCString)
                            print(typeName)
                        }
                    }
                }
            }
        }
    }

}
