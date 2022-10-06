//
//  Inspection.swift
//  RuntimeC
//
//  Created by Nikita Skrypchenko on 04.10.2022.
//

import Foundation


func inspect(_ cclass: AnyObject.Type) {
    // Inspection IVars
    var ivarCount : UInt32 = 0
    let ivars : UnsafeMutablePointer<Ivar>? = class_copyIvarList(cclass, &ivarCount)
    for i in 0..<ivarCount {
        guard
            let iv = ivars,
            let ivarName = ivar_getName(iv[Int(i)]),
            let ivarTypeEncoding = ivar_getTypeEncoding(iv[Int(i)])
        else { return }
        
        print("Ivar: " + String(cString: ivarName))
        print(" " + String(cString: ivarTypeEncoding))
    }
    
    // Properties
    var propertyCount : UInt32 = 0
    let properties : UnsafeMutablePointer<objc_property_t>? = class_copyPropertyList(cclass, &propertyCount)

    for i in 0..<propertyCount {
        guard let pr = properties else { return }
        print("Property: " + String(cString: property_getName(pr[Int(i)])))
    }
    
    //Protocols
    var protocolsCount : UInt32 = 0
    let protocols : AutoreleasingUnsafeMutablePointer<Protocol>? = class_copyProtocolList(cclass, &protocolsCount)

    for i in 0..<propertyCount {
        guard let pr = protocols else { return }
        print("Property: " + String(cString: protocol_getName(pr[Int(i)])))
    }
}
