//
//  LotoQuebec.swift
//  jeuRioPoker
//
//  Created by Andre Cruz on 17-10-19.
//  Copyright © 2017 Andre Cruz. All rights reserved.
//

import UIKit

class LotoQuebec: UIViewController {
//---
    // Déclaration des composants utilisés
    @IBOutlet weak var lotoPresente: UIImageView!
    @IBOutlet weak var continuezButton: UIButton!
//---
    override func viewDidLoad() {
        super.viewDidLoad()
    //---
        // Arrondissage des bords
        lotoPresente.layer.cornerRadius = 20
        lotoPresente.layer.masksToBounds = true
    //---
        // Il cache le bouton
        continuezButton.isHidden = true
        // Il montre le bouton après 2 secondes en utilisant la fonction enableButton
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(enableButton), userInfo: nil, repeats: false)
    //---
        // Appel des fonctions d'animation
        animationScaleUp()
        animationScaleDown()
    //---
    }
//---
    // Fonctions d'animation du bouton continuez
    private func animationScaleUp(){
        UIView.animate(withDuration: 0.4, delay: 1, options: [.curveEaseIn, .allowUserInteraction],  animations: {self.continuezButton.transform = CGAffineTransform (scaleX: 1.3, y: 1.3)}) {(true) in self.animationScaleUp()}
    }
    
    private func animationScaleDown(){
        UIView.animate(withDuration: 0.4, delay: 1, options: [.curveEaseOut, .allowUserInteraction],  animations: {self.continuezButton.transform = CGAffineTransform (scaleX: 1, y: 1)}) {(true) in self.animationScaleDown()}
    }
    //---
    // Fonction qui montre le bouton
    func enableButton() {
        continuezButton.isHidden = false
    }
//---
}
