//
//  SelectionViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 08/10/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class SelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var hometownLabel: UILabel!
    @IBOutlet weak var weddingDateLabel: UILabel!
    @IBOutlet weak var dressesLabel: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backHomeScreen: UIBarButtonItem!
    
    var dresses = [Dress]()
    var selectedDresses = [Dress]()
    var dressNames = [String]()
    var provCart: Cart!
    weak var cart: CartMO!
    var dressesRecord = [DressMO]()
    var cities = [CityMO]()
    var languageIndex: Int!
    
    var titleLang: [String] = ["WYBRANE MODELE","SELECTED MODELS","MODELOS SELECCIONADOS"]
    var homeLang: [String] = ["POWRÓT","HOME","INICIO"]
    var nameLang: [String] = ["Imię:","Name:","Nombre:"]
    var lastnameLang: [String] = ["Nazwisko:","Lastname:","Apellidos:"]
    var hometownLang: [String] = ["Miasto:","City:","Ciudad:"]
    var weddingDateLang: [String] = ["Data Ślubu:","Wedd. Date:","Fecha Boda:"]
    var confirmLang: [String] = ["","CONFIRM SELECTION","CONFIRMAR SELECCIÓN"]
    var confirmationMessageLang: [[String]] = [["To wszystko","Dziękuję, proszę przekazać urządzenie pracownikowi salonu.","Gotowe"],["Ready","Thank you, please give back the device to the person who attended you.","Ok"],["Listo","Gracias, devuelva el dispositivo a la persona que lo atendió.","Vale"]]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        provCart.dresses = dressNames
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "" ,style: .plain, target: nil, action: nil)
        nameLabel.text = nameLang[languageIndex] + " " + provCart.name
        lastnameLabel.text = lastnameLang[languageIndex] + " " + provCart.lastname
        hometownLabel.text = hometownLang[languageIndex] + " " + provCart.city
        weddingDateLabel.text = weddingDateLang[languageIndex] + " " + provCart.weddingDate
        if languageIndex != 0 {
            
            saveButton.setTitle(confirmLang[languageIndex], for: .normal)
        }
        navigationItem.title = titleLang[languageIndex]
        backHomeScreen.title = homeLang[languageIndex]
        backHomeScreen.tintColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
        
        let maskPathSave = UIBezierPath(roundedRect: saveButton.bounds, byRoundingCorners: [.bottomRight, .bottomLeft], cornerRadii: CGSize(width: 10.0, height: 10.0))
        
        let maskLayerSave = CAShapeLayer()
        maskLayerSave.path = maskPathSave.cgPath
        saveButton.layer.mask = maskLayerSave
        
        let maskPathLabel = UIBezierPath(roundedRect: saveButton.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 10.0, height: 10.0))
        
        let maskLayerLabel = CAShapeLayer()
        maskLayerLabel.path = maskPathLabel.cgPath
        dressesLabel.layer.mask = maskLayerLabel
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as! SelectionTableViewCell
        tableView.separatorColor = UIColor(red: 197/255, green: 176/255, blue: 120/255, alpha: 1)
        let dress = selectedDresses[indexPath.row]
        
        // Configure the cell
        cell.dressLabel.font = UIFont(name: "TrajanPro-Regular", size: 32)
        cell.dressLabel.text = dress.name
        cell.dressImageView.image = UIImage(named: dress.imgName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let popImageView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectedDressView") as! SelectedDressViewController
        popImageView.dressImage = selectedDresses[indexPath.row].imgName
        self.addChildViewController(popImageView)
        popImageView.view.frame = self.view.frame
        self.view.addSubview(popImageView.view)
        popImageView.didMove(toParentViewController: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func clearAllVariables() {
        cart = nil
        provCart = nil
        dresses.removeAll()
        selectedDresses.removeAll()
        dressesRecord.removeAll()
        dressNames.removeAll()
        cities.removeAll()
        tableView = nil
    }
    
    @IBAction func saveSelectionToCart(_ sender: UIButton) {
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            cart = CartMO(context: appDelegate.persistentContainer.viewContext)
            cart.name = provCart.name
            cart.lastname = provCart.lastname
            cart.email = provCart.email
            cart.phone = provCart.phone
            cart.city = provCart.city
            cart.weddingDate = provCart.weddingDate
            cart.dresses = provCart.dresses as NSArray?
            
            appDelegate.saveContext()
            
            let alertController = UIAlertController(title: confirmationMessageLang[languageIndex][0], message: confirmationMessageLang[languageIndex][1], preferredStyle: .alert)
            let alertAction = UIAlertAction(title: confirmationMessageLang[languageIndex][2], style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion:nil)
            
            saveButton.isEnabled = false
            saveButton.alpha = 0.25
            navigationItem.backBarButtonItem!.tintColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
            navigationItem.backBarButtonItem!.isEnabled = false
            backHomeScreen.tintColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
            backHomeScreen.isEnabled = true
        }
    }
    
    @IBAction func backToHomeScreen(_ sender: UIBarButtonItem) {
        clearAllVariables()
        self.performSegue(withIdentifier: "unwindToHomeScreen", sender: self)
        self.dismiss(animated: false)
    }
}
