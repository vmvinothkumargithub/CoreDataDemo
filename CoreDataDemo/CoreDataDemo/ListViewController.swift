//
//  ListViewController.swift
//  CoreDataDemo
//
//  Created by Vinoth on 25/01/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController
{
    var employeeArray = [Employee]()
    var tblView : UITableView!

    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //as! only then auto completion fetched persistentContainer
    
    override func loadView() {
        super.loadView()
        let tblView = UITableView()
        tblView.delegate = self
        tblView.dataSource = self
        tblView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tblView)
        
        NSLayoutConstraint.activate([
            tblView.topAnchor.constraint(equalTo: view.topAnchor),
            tblView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tblView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tblView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        self.tblView = tblView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewEmployee))
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.employeeArray = fetchAllEmployees()
        self.tblView.reloadData()
    }
    
    func fetchAllEmployees() -> [Employee]
    {
        var result : [Employee] = []
        
        //let request = Employee.fetchRequest()
        //Ambiguous use of 'fetchRequest()'
        
        let requestA : NSFetchRequest = Employee.fetchRequest()
        let requestB = Employee.fetchRequest() as NSFetchRequest
        let requestC : NSFetchRequest<Employee> = Employee.fetchRequest()
        //all works

        do{
            result = try moc.fetch(requestA)
            //fetch result can be directly assigned to [Employee]
            print(result)
        }catch let error as NSError{
            print("MyError:\(error)")
        }
        return result
    }
    
    @objc func addNewEmployee(){
        self.performSegue(withIdentifier: "addEmployee", sender: nil)
    }
}


extension ListViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let employee = employeeArray[indexPath.row]
        cell.textLabel?.text = employee.name
        cell.detailTextLabel?.text = String(employee.age)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employee = employeeArray[indexPath.row]
        self.performSegue(withIdentifier: "addEmployee", sender: employee)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let bookController = segue.destination as? BookViewController, let employee = sender as? Employee
        {
            bookController.employee = employee
        }
    }
}
