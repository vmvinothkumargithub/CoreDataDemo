//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Vinoth on 25/01/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class BookViewController: UIViewController {

    var employee : Employee?
    
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfAge : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //name
        let lblName = UILabel()
        lblName.text = "Name"
        lblName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lblName)
        
        let tfName = UITextField()
        tfName.borderStyle = .roundedRect
        tfName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tfName)
        
        lblName.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        lblName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        
        tfName.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        tfName.leftAnchor.constraint(equalTo: lblName.rightAnchor, constant: 30).isActive = true
        tfName.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        
        tfName.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        
        
        
        
        //age
        let lblAge = UILabel()
        lblAge.text = "Ageeeee"
        lblAge.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lblAge)
        
        let tfAge = UITextField()
        tfAge.borderStyle = .roundedRect
        tfAge.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tfAge)
        tfAge.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)

        
        NSLayoutConstraint.activate([
            lblAge.topAnchor.constraint(equalTo: lblName.bottomAnchor, constant: 40),
            lblAge.leftAnchor.constraint(equalTo:lblName.leftAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tfAge.centerYAnchor.constraint(equalTo: lblAge.centerYAnchor, constant: 0),
            tfAge.leadingAnchor.constraint(equalTo: tfName.leadingAnchor, constant: 0),
            tfAge.trailingAnchor.constraint(equalTo: tfName.trailingAnchor, constant: -20)
        ])
        
        
        //save, delete
        let btnSave = UIButton(type: .system)
        btnSave.setTitle("Save", for: .normal)
        btnSave.translatesAutoresizingMaskIntoConstraints = false
        btnSave.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(btnSave)

        let btnDelete = UIButton(type: .system)
        btnDelete.setTitle("Delete", for: .normal)
        btnDelete.translatesAutoresizingMaskIntoConstraints = false
        btnDelete.addTarget(self, action: #selector(deleteButtonTapped(name:)), for: .touchUpInside)
        view.addSubview(btnDelete)
        
        NSLayoutConstraint.activate([
            btnSave.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 150),
            btnSave.topAnchor.constraint(equalTo: tfAge.bottomAnchor, constant: 40),
            btnDelete.leadingAnchor.constraint(equalTo: btnSave.leadingAnchor, constant: 80),
            btnDelete.topAnchor.constraint(equalTo: tfAge.bottomAnchor, constant: 40),
        ])
        
        self.tfName = tfName
        self.tfAge  = tfAge
        
        if let employee = employee {
            self.tfName.text = employee.name
            self.tfAge.text  = String(employee.age)
        }
    }
    
    @objc func saveButtonTapped()
    {
        guard let name = self.tfName.text?.trimmingCharacters(in: .whitespacesAndNewlines), name.count > 0 else {
            return
        }
        
        guard let age = self.tfAge.text?.trimmingCharacters(in: .whitespacesAndNewlines), age.count > 0, let age32 = Int32(age) else {
            return
        }

        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: moc) as! Employee
        
        //employee.age  = Int32(self.tfAge.text)
        //Initializer 'init(_:)' requires that '(UITextRange) -> String?' conform to 'BinaryInteger'
        
        //employee.age  = Int32(self.tfAge.text!)
        //Value of optional type 'Int32?' must be unwrapped to a value of type 'Int32'
                
        //employee.age  = Int32(self.tfAge.text!)!
        //No errors - understand the errors popped up
        
        employee.name = name
        employee.age  = age32
        
        //moc.save()
        //Call can throw, but it is not marked with 'try' and the error is not handled
        
        do{
            try moc.save()
        }catch let error as NSError{
            print("MyError : \(error)")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteButtonTapped(name:AnyObject){
        do{
            if let employee = employee{
                moc.delete(employee)
                try moc.save()
            }
        }catch let error as NSError{
            print("MyError : \(error)")
        }
        self.navigationController?.popViewController(animated: true)
    }
}

