//
//  UserDefaultsManager.swift
//  jeuRioPoker
//
//  Created by eleves on 17-10-18.
//  Copyright © 2017 Andre Cruz. All rights reserved.
//

import Foundation

// classe UserDefaultsManager

class UserDefaultsManager {
    //---
    func doesKeyExist(theKey: String) -> Bool {
        if UserDefaults.standard.object(forKey: theKey) == nil {
            return false
        }
        //---
        return true // la meme chose que le else
    }
    //---
    // AnyObject > N'import quelle object
    func setKey(theValue: AnyObject, theKey: String) {
        UserDefaults.standard.set(theValue, forKey: theKey)
    }
    //---
    // Eliminer une cle de la memoire
    func removeKey (theKey: String) {
        UserDefaults.standard.removeObject(forKey: theKey)
    }
    //---
    // Chercher la valeur d'une clé
    func getValue (theKey: String) -> AnyObject {
        return UserDefaults.standard.object(forKey: theKey) as AnyObject
    }
    //---
}

