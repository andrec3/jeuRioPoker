//====================================================
//  ViewController.swift
//  jeuRioPoker
//
//  Created by Andre Cruz on 17-10-16.
//  Copyright © 2017 Andre Cruz. All rights reserved.
//====================================================


//----------------------//----------------------
import UIKit
//---
import AVFoundation
//----------------------//----------------------
class ViewController: UIViewController {
    @IBOutlet weak var tempLabel: UILabel!
    //---
    // Les cinq ImageViews (slots) pour montrer les cartes
    @IBOutlet weak var slot_1: UIImageView!
    @IBOutlet weak var slot_2: UIImageView!
    @IBOutlet weak var slot_3: UIImageView!
    @IBOutlet weak var slot_4: UIImageView!
    @IBOutlet weak var slot_5: UIImageView!
    //---
    // Les variables qui représentent les huit images flou pour faire l'animation
    var card_flou_1: UIImage!
    var card_flou_2: UIImage!
    var card_flou_3: UIImage!
    var card_flou_4: UIImage!
    var card_flou_5: UIImage!
    var card_flou_6: UIImage!
    var card_flou_7: UIImage!
    var card_flou_8: UIImage!
    //---
    // Les View qui contiennent une ImageView pour voir la carte, un bouton pour cliquer (faire la selection) et un label pour montrer Garder
    @IBOutlet weak var bg_1: UIView!
    @IBOutlet weak var bg_2: UIView!
    @IBOutlet weak var bg_3: UIView!
    @IBOutlet weak var bg_4: UIView!
    @IBOutlet weak var bg_5: UIView!
    //---
    // Les connexions vers les Labels qui sont hidden
    @IBOutlet weak var keep_1: UILabel!
    @IBOutlet weak var keep_2: UILabel!
    @IBOutlet weak var keep_3: UILabel!
    @IBOutlet weak var keep_4: UILabel!
    @IBOutlet weak var keep_5: UILabel!
    //---
    
    @IBOutlet weak var dealButton: UIButton!  // Le connexion ver les boutons miser
    @IBOutlet weak var creditsLabel: UILabel! // Le Label pour le credit
    @IBOutlet weak var betLabel: UILabel!     // Le Label pour le bet
    @IBOutlet weak var resetButton: UIButton! // Le bouton pour recommencer le jeu quand le credit est zero
    @IBOutlet weak var bet25: UIButton!       // Les boutons bet pour faire l'interaction
    @IBOutlet weak var bet100: UIButton!
    @IBOutlet weak var betAll: UIButton!
    //---
    var arrOfCardImages: [UIImage]!         // Le tableau pour les images
    //---
    var arrOfSlotImageViews: [UIImageView]! // Le tableau pour les ImagesViews
    //---
    var deckOfCards = [(Int, String)]()     // Le tableau pour creer le jeu des cartes
    //---
    var arrOfBackgrounds: [UIView]!         // Le tableau pour les backgrouds
    //---
    var arrOfKeepLabels: [UILabel]!         // Le tableau pour les keeplabels
    //---
    var permissionToSelectCards = false // Variable créée pour empêcher a certain moment qui les cartes soient choisis
    var bet = 0 // L'initialisation de la variable bet égale à zéro
    var credits = 2000 // L'initialisation de la variable credits égale à 2000
    //---
    var chances = 2  // La variable qui gère le numero des chances d'utilisateur
    //---
    let pokerHands = PokerHands() // L'instanciation de l'objet selon la classe PokerHands
    //---
    var handToAnalyse = [(0, ""), (0, ""), (0, ""), (0, ""), (0, "")] // Le tableau de deux pôles qui représente la main que va être analysée
    //---
    var theHand = [(Int, String)]()
    //---
    var sonButtonEffect: AVAudioPlayer?  // La variable pour l'effet sonore du bouton
    //---
    var sonCardsEffect: AVAudioPlayer?  // La variable pour l'effet sonore des cartes - le son est bas
    //----------------------//----------------------
    let userDef = UserDefaultsManager()  // L'appel de la classe qui garde le crédit
    //----------------------//----------------------
    override func viewDidLoad() {
        //---
        super.viewDidLoad()
        //---
        verifyCredit() // L'appel de la méthode qui va montrer le dernier crédit
        //---
        creditsLabel.text = "CRÉDITS : \(credits)" // L'affichage du dernier crédit
        //---
        createCardObjectsFromImages() // La méthode pour creer les objects a partir des images
        //---
        fillUpArrays() // Ramplir les different tableau
        //---
        prepareAnimations(duration: 0.5,
                          repeating: 5,
                          cards: arrOfCardImages)
        //---
        stylizeSlotImageViews(radius: 10,
                              borderWidth: 0.5,
                              borderColor: UIColor.black.cgColor,
                              bgColor: UIColor.yellow.cgColor) // Donne une style au slotImageViews
        //---
        stylizeBackgroundViews(radius: 10,
                               borderWidth: nil,
                               borderColor: UIColor.black.cgColor,
                               bgColor: nil) // Donne une style au background
        //---
        createDeckOfCards() // Exécuter la méthode qui va créer le deck of cards
        //---
    }
    //----------------------//----------------------
    // La fonction avec une boucle exterieur et une boucle interieur qui va créer le deck of cards
    func createDeckOfCards() {
        deckOfCards = [(Int, String)]()
        for a in 0...3 { // Quatre interactions
            let suits = ["d", "h", "c", "s"]
            for b in 1...13 { // Treize interactions
                deckOfCards.append((b, suits[a])) // 52 cartes
            }
        }
    }
    //----------------------//----------------------
    // La méthode avec des paramètres externes et internes pour optimiser le code
    func stylizeSlotImageViews(radius r: CGFloat,
                               borderWidth w: CGFloat,
                               borderColor c: CGColor,
                               bgColor g: CGColor!) {
        for slotImageView in arrOfSlotImageViews {
            slotImageView.clipsToBounds = true
            slotImageView.layer.cornerRadius = r
            slotImageView.layer.borderWidth = w
            slotImageView.layer.borderColor = c
            slotImageView.layer.backgroundColor = g
        }
    }
    //----------------------//----------------------
    // La méthode avec des paramètres externes et internes
    func stylizeBackgroundViews(radius r: CGFloat,
                                borderWidth w: CGFloat?, // Ici c'est optionnel (?)
                                borderColor c: CGColor,
                                bgColor g: CGColor?) {
        for bgView in arrOfBackgrounds {
            bgView.clipsToBounds = true
            bgView.layer.cornerRadius = r
            bgView.layer.borderWidth = w ?? 0
            bgView.layer.borderColor = c
            bgView.layer.backgroundColor = g
        }
    }
    //----------------------//----------------------
    func fillUpArrays() {
        arrOfCardImages = [card_flou_1, card_flou_2, card_flou_3, card_flou_4,
                           card_flou_5, card_flou_6, card_flou_7, card_flou_8]
        arrOfSlotImageViews = [slot_1, slot_2, slot_3, slot_4, slot_5]
        arrOfBackgrounds = [bg_1, bg_2, bg_3, bg_4, bg_5]
        arrOfKeepLabels = [keep_1, keep_2, keep_3, keep_4, keep_5]
    }
    //----------------------//----------------------
    // La méthode qui crée les cartes flou a partir des images png
    func createCardObjectsFromImages() {
        card_flou_1 = UIImage(named: "flou1.png")
        card_flou_2 = UIImage(named: "flou2.png")
        card_flou_3 = UIImage(named: "flou3.png")
        card_flou_4 = UIImage(named: "flou4.png")
        card_flou_5 = UIImage(named: "flou5.png")
        card_flou_6 = UIImage(named: "flou6.png")
        card_flou_7 = UIImage(named: "flou7.png")
        card_flou_8 = UIImage(named: "flou8.png")
    }
    //----------------------//----------------------
    // La méthode pour préparer l'animation
    func prepareAnimations(duration d: Double,
                           repeating r: Int,
                           cards c: [UIImage]) {
        for slotAnimation in arrOfSlotImageViews {
            slotAnimation.animationDuration = d
            slotAnimation.animationRepeatCount = r
            slotAnimation.animationImages = returnRandomBlurCards(arrBlurCards: c)
        }
    }
    //----------------------//----------------------
    // La méthode pour mélanger les blur cards (flou cartes)
    func returnRandomBlurCards(arrBlurCards: [UIImage]) -> [UIImage] {
        var arrToReturn = [UIImage]()
        var arrOriginal = arrBlurCards
        for _ in 0..<arrBlurCards.count {
            let randomIndex = Int(arc4random_uniform(UInt32(arrOriginal.count)))
            arrToReturn.append(arrOriginal[randomIndex])
            arrOriginal.remove(at: randomIndex)
        }
        return arrToReturn
    }
    //----------------------//----------------------
    // Le bouton distribuer - Faire l'animation
    @IBAction func play(_ sender: UIButton) {
        cardSon()
        //---
        // Qui va arriver quand la chance est égal à zero - Le bouton va bloquer
        if chances == 0 || dealButton.alpha == 0.5 {
            return
        } else {
            chances = chances - 1
        }
        //---
        // Dans le cas où toutes les cartes sont choisies l'animation n'arrivera pas.
        var allSelected = true
        for slotAnimation in arrOfSlotImageViews {
            if slotAnimation.layer.borderWidth != 1.0 {
                allSelected = false
                break
            }
        }
        // L'animation n'arrivera si la variable est égale à false
        if allSelected {
            displayRandomCards()
            return
        }
        //---
        for slotAnimation in arrOfSlotImageViews {
            if slotAnimation.layer.borderWidth != 1.0 {
                slotAnimation.startAnimating()
            }
        }
        //---
        // Le temps de l'animation
        Timer.scheduledTimer(timeInterval: 2.55,
                             target: self,
                             selector: #selector(displayRandomCards),
                             userInfo: nil,
                             repeats: false)
        //---
    }
    //----------------------//----------------------
    // La méthode qui va choisir les cartes au hasard
    @objc func displayRandomCards() {
        //---
        theHand = returnRandomHand()
        //---
        let arrOfCards = createCards(theHand: theHand)
        //---
        displayCards(arrOfCards: arrOfCards)
        //---
        permissionToSelectCards = true
        //---
        prepareForNextHand()
        //---
    }
    //----------------------//----------------------
    // La méthode qui prépare le jeu par la prochine main
    func prepareForNextHand() {
        //---
        if chances == 0 {
            permissionToSelectCards = false
            dealButton.alpha = 0.5
            resetButton.alpha = 1 // Il permet le bouton quand chances = 0
            resetCards()
            createDeckOfCards() // Il crée à nouveau
            handToAnalyse = [(0, ""), (0, ""), (0, ""), (0, ""), (0, "")]
            chances = 2
            bet = 0
            betLabel.text = "MISE : 0"
        }
        //---
        if credits != 0 {
            resetButton.alpha = 0.5 // Il maintient le bouton fermé quand credit != 0
        } else if credits == 0 && bet == 0 {
            zeroCredit()
        }

        //---
    }
    //----------------------//----------------------
    // La méthode qu'affiche les cartes
    func displayCards(arrOfCards: [String]) {
        //---
        var counter = 0 // Si chance est égal à zero
        for slotAnimation in arrOfSlotImageViews {
            if slotAnimation.layer.borderWidth != 1 {
                if chances == 0 {
                    handToAnalyse = removeEmptySlotsAndReturnArray() // Enleve les espace vides
                    handToAnalyse.append(theHand[counter])
                }
                //---
                slotAnimation.image = UIImage(named: arrOfCards[counter])
            }
            counter = counter + 1
        }
        //---
        if chances == 0 {
            verifyHand(hand: handToAnalyse) // Les cartes selectionées + l'autres (2éme fois)
        }
        //---
    }
    //----------------------//----------------------
    // La méthode pour enlever les cartes vides
    func removeEmptySlotsAndReturnArray() -> [(Int, String)] {
        var arrToReturn = [(Int, String)]()
        for card in handToAnalyse {
            if card != (0, "") {
                arrToReturn.append(card)
            }
        }
        return arrToReturn
    }
    //----------------------//----------------------
    // La création des cartes a partir de deux pôles
    func createCards(theHand: [(Int, String)]) -> [String] {
        //---
        let card_1 = "\(theHand[0].0)\(theHand[0].1).png"
        let card_2 = "\(theHand[1].0)\(theHand[1].1).png"
        let card_3 = "\(theHand[2].0)\(theHand[2].1).png"
        let card_4 = "\(theHand[3].0)\(theHand[3].1).png"
        let card_5 = "\(theHand[4].0)\(theHand[4].1).png"
        return [card_1, card_2, card_3, card_4, card_5]
        //---
    }
    //----------------------//----------------------
    func returnRandomHand() -> [(Int, String)] {
        //---
        var arrToReturn = [(Int, String)]()
        //---
        for _ in 1...5 {
            let randomIndex = Int(arc4random_uniform(UInt32(deckOfCards.count)))
            arrToReturn.append(deckOfCards[randomIndex])
            deckOfCards.remove(at: randomIndex)
        }
        //---
        return arrToReturn
        //---
    }
    //----------------------//----------------------
    // La méthode pour verify le main
    func verifyHand(hand: [(Int, String)]) {
        if pokerHands.royalFlush(hand: hand) {
            calculateHand(times: 250, handToDisplay: "QUINTE FLUSH ROYALE")
        } else if pokerHands.straightFlush(hand: hand) {
            calculateHand(times: 50, handToDisplay: "QUINTE FLUSH")
        } else if pokerHands.fourKind(hand: hand) {
            calculateHand(times: 25, handToDisplay: "CARRÉ")
        } else if pokerHands.fullHouse(hand: hand) {
            calculateHand(times: 9, handToDisplay: "MAIN PLEINE")
        } else if pokerHands.flush(hand: hand) {
            calculateHand(times: 6, handToDisplay: "COULEUR")
        } else if pokerHands.straight(hand: hand) {
            calculateHand(times: 4, handToDisplay: "QUINTE")
        } else if pokerHands.threeKind(hand: hand) {
            calculateHand(times: 3, handToDisplay: "BRELAN")
        } else if pokerHands.twoPairs(hand: hand) {
            calculateHand(times: 2, handToDisplay: "DEUX PAIRES")
        } else if pokerHands.onePair(hand: hand) {
            calculateHand(times: 1, handToDisplay: "PAIRE")
        } else {
            calculateHand(times: 0, handToDisplay: "RIEN...")
        }
    }
    //----------------------//----------------------
    // Le méthode qui fait le calcul
    func calculateHand(times: Int, handToDisplay: String) {
        credits += (times * bet)
        tempLabel.text = handToDisplay // Affiche le message
        creditsLabel.text = "CRÉDITS: \(credits)" // Affiche le credits
        //---
        // L'appel du méthode pour garder le credit après le calcul du credit
        userDef.setKey(theValue: credits as AnyObject, theKey: "credits")
    }
    //----------------------//----------------------
    // La méthode pour faire la gestion de les cartes selectionées ou pas selectionées
    @IBAction func cardsToHold(_ sender: UIButton) {
        //---
        if !permissionToSelectCards {
            return
        }
        //---
        if arrOfBackgrounds[sender.tag].layer.borderWidth == 0.5 {
            arrOfSlotImageViews[sender.tag].layer.borderWidth = 0.5
            arrOfBackgrounds[sender.tag].layer.borderWidth = 0.0
            arrOfBackgrounds[sender.tag].layer.backgroundColor = nil
            arrOfKeepLabels[sender.tag].isHidden = true
            //---
            manageSelectedCards(theTag: sender.tag, shouldAdd: false)
        } else {
            arrOfSlotImageViews[sender.tag].layer.borderWidth = 1.0
            arrOfBackgrounds[sender.tag].layer.borderWidth = 0.5
            arrOfBackgrounds[sender.tag].layer.borderColor = UIColor.blue.cgColor
            arrOfBackgrounds[sender.tag].layer.backgroundColor = UIColor(red: 0.0,
                                                                         green: 0.0, blue: 1.0, alpha: 0.5).cgColor
            arrOfKeepLabels[sender.tag].isHidden = false
            //---
            manageSelectedCards(theTag: sender.tag, shouldAdd: true)
        }
    }
    //----------------------//----------------------
    // La méthode pour ajouter la tag à une position vide
    func manageSelectedCards(theTag: Int, shouldAdd: Bool) {
        if shouldAdd {
            handToAnalyse[theTag] = theHand[theTag]
        } else {
            handToAnalyse[theTag] = (0, "")
        }
    }
    //----------------------//----------------------
    // Les boutons pour miser
    @IBAction func betButtons(_ sender: UIButton) {
        //---
        boutonSon() // Le son du bouton
        //---
        if chances <= 1 {
            return
        }
        //---
        tempLabel.text = ""
        //---
        // Le bouton pour miser tout
        if sender.tag == 1000 {
            bet += credits // Il ajoute le reste des crédits à mise
            betLabel.text = "MISE : \(bet)"
            credits = 0
            creditsLabel.text = "CRÉDITS : \(credits)" // Il affiche le credits
            dealButton.alpha = 1.0
            resetBackOfCards()
            return // Arrete ici
        }
        //---
        let theBet = sender.tag
        //---
        // Les boutons 25 et 100
        if credits >= theBet {
            bet += theBet
            credits -= theBet
            betLabel.text = "MISE : \(bet)"
            creditsLabel.text = "CRÉDITS : \(credits)"
            dealButton.alpha = 1.0
        }
        //---
        // Il montre le dos des cartes pour commencer à miser
        resetBackOfCards()
        //---
    }
    //----------------------//----------------------
    // Le bouton pour recommencer le jeu
    @IBAction func resetJeu(_ sender: UIButton) {
        //---
        if sender.alpha == 0.5 {
            return
        }
        //---
        credits = 2000
        creditsLabel.text = "CRÉDITS : \(credits)"
        betLabel.text = "MISE : 0"
        prepareForNextHand()
        resetBackOfCards()
        resetButton.alpha = 0.5
        bet25.isEnabled = true
        bet100.isEnabled = true
        betAll.isEnabled = true
        boutonSon()
        // L'appel du méthode pour garder le credit après le recommencer du jeu
        userDef.setKey(theValue: credits as AnyObject, theKey: "credits")
        //---
    }
    //----------------------//----------------------
    // La méthode pour montrer back image dans le dos de la carte
    func resetBackOfCards() {
        for back in arrOfSlotImageViews {
            back.image = UIImage(named: "back.png")
        }
    }
    //----------------------//----------------------
    // La méthode pour faire le reset des cartes
    func resetCards() {
        //---
        for index in 0...4 {
            arrOfSlotImageViews[index].layer.borderWidth = 0.5
            arrOfBackgrounds[index].layer.borderWidth = 0.0
            arrOfBackgrounds[index].layer.backgroundColor = nil
            arrOfKeepLabels[index].isHidden = true
        }
        //---
        chances = 2
        //---
    }
    //----------------------//----------------------
    // La méthode pour garder les crédits
    func verifyCredit() {
        // Verifier si le clé exist pas
        if !userDef.doesKeyExist(theKey: "credits") {
            userDef.setKey(theValue: credits as AnyObject, theKey: "credits")
        } else {
            // si exist
            credits = userDef.getValue(theKey: "credits") as! Int
        }
        //---
        // Quand le crédit est égal à zero il apple la méthode zeroCredit
        if credits == 0 {
            zeroCredit()
        }
    }
    //----------------------//----------------------
    // La méthode pour désactivér les boutons bet e activer le bouton recommancer
    func zeroCredit() {
        resetButton.alpha = 1
        bet25.isEnabled = false
        bet100.isEnabled = false
        betAll.isEnabled = false
    }
    //----------------------//----------------------
    // La méthode pour donner un effect sonore aux boutons
    func boutonSon() {
        let path = Bundle.main.path(forResource: "button_hint.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            sonButtonEffect = try AVAudioPlayer(contentsOf: url)
            sonButtonEffect?.play()
            sleep(1)
            sonButtonEffect?.stop()
        } catch {
            // Ne pouvait pas charger le fichier :(
        }
    }
    //----------------------//----------------------
    // La méthode pour donner un effect sonore quand l'animation des cartes blur commence
    func cardSon() {
        let path = Bundle.main.path(forResource: "pandeiro.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            sonCardsEffect = try AVAudioPlayer(contentsOf: url)
            sonCardsEffect?.play()
        } catch {
            // Ne pouvait pas charger le fichier :(
        }
    }
    //----------------------//----------------------
}

//----------------------//----------------------
//Credit: Sound buton https://freesound.org/s/320181/
