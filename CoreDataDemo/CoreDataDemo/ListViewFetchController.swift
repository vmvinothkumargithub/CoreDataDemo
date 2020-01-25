//
//  ListViewController.swift
//  CoreDataDemo
//
//  Created by Vinoth on 25/01/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit
import CoreData

class ListViewFetchController: UIViewController
{
    var tblView : UITableView!

    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //as! only then auto completion fetched persistentContainer
    
    lazy var fetchController:NSFetchedResultsController<Employee> = {
        let request = NSFetchRequest<Employee>(entityName: "Employee")
        request.sortDescriptors = [NSSortDescriptor(key: "age", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext:self.moc, sectionNameKeyPath: nil, cacheName: nil)
        //if not lazy, then self.moc produces error
        controller.delegate = self
        return controller
    }()
    
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
        try? fetchController.performFetch()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func addNewEmployee(){
        self.performSegue(withIdentifier: "addEmployee", sender: nil)
    }
}


extension ListViewFetchController : UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let section = fetchController.sections[section]
        //Value of optional type '[NSFetchedResultsSectionInfo]?' must be unwrapped to refer to member 'subscript' of wrapped base type '[NSFetchedResultsSectionInfo]'
        //Chain the optional using '?' to access member 'subscript' only for non-'nil' base values
        //Force-unwrap using '!' to abort execution if the optional value contains 'nil'
        
        if let section = fetchController.sections?[section]{
            return section.numberOfObjects
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let section = fetchController.sections{
            return section.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let employee = fetchController.object(at: indexPath)
        cell.textLabel?.text = employee.name
        cell.detailTextLabel?.text = String(employee.age)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employee = fetchController.object(at: indexPath)
        self.performSegue(withIdentifier: "addEmployee", sender: employee)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let bookController = segue.destination as? BookViewController, let employee = sender as? Employee
        {
            bookController.employee = employee
        }
    }
    
    //None of methods in NSFetchedResultsControllerDelegate is mandatory, all are optional
    
    /*
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblView.endUpdates()
    }
    */
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tblView.reloadData()
    }
    //controller:willChangeContent
    //controller:didChangeContent
    //controller:didChangeObject:atIndexPath
    /*
     If I implement all above 3 methods and inserted a new employee then run time error as below
     *** Terminating app due to uncaught exception
    'NSInternalInconsistencyException', reason: 'Invalid update:
     invalid number of rows in section 0. The number of rows
     contained in an existing section after the update (9) must be
     equal to the number of rows contained in that section before the
     update (8), plus or minus the number of rows inserted or deleted
     from that section (0 inserted, 0 deleted) and plus or minus the
     number of rows moved into or out of that section (0 moved in, 0
     moved out).'
     
     //I commented both willChangeContent and didChangeContent, then no crash ==> Instead of reload, I should add, remove, update and move the sections
     */
}
