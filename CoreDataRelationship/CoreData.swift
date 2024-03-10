//
//  CoreData.swift
//  CoreDataRelationship
//
//  Created by Feihuan Peng on 3/9/24.
//

import Foundation
import CoreData

class CoreDataRelationshipViewModel: ObservableObject {
    let manager = CoreDataManager.instance
    @Published var businesses: [BusinessEntity] = []
    @Published var departments: [DepartmentEntity] = []
    @Published var employees: [EmployeeEntity] = []
    
    init() {
        getBusinesses()
        getDepartments()
        getEmployees()
    }
    
    
    func getBusinesses() {
        let request = NSFetchRequest<BusinessEntity>(entityName: "BusinessEntity")
        
        // sort
        let sort = NSSortDescriptor(keyPath: \BusinessEntity.name, ascending: true)
        request.sortDescriptors = [sort]
        
        // filter by attribute match
//        let filter = NSPredicate(format:"name == %@", "bb")
//        request.predicate = filter
        
        do {
            businesses = try manager.context.fetch(request)
        } catch let error {
            print("error fetching businesses: \(error)")
        }
    }
    
    func getDepartments() {
        let request = NSFetchRequest<DepartmentEntity>(entityName: "DepartmentEntity")
        
        do {
            departments = try manager.context.fetch(request)
        } catch let error {
            print("error fetching Department: \(error)")
        }
    }
        
    func getEmployees() {
        let request = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        
        do {
            employees = try manager.context.fetch(request)
        } catch let error {
            print("error fetching employees: \(error)")
        }
    }
    
    // same name is fine // only can filte to one
    func getEmployees(forBusiness business: BusinessEntity) {
        let request = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
                let filter = NSPredicate(format:"name == %@", business)
                request.predicate = filter
        do {
            employees = try manager.context.fetch(request)
        } catch let error {
            print("error fetching employees: \(error)")
        }
    }
    
    func addBusiness() {
        let newBusiness = BusinessEntity(context: manager.context)
        newBusiness.name = "bb"
        
        //add existing department and employee to business
        
        // newBusiness.departments = []
        //newBusiness.employees = []
        // add new business to existing department and employee
        // newBusiness.addToDepartments(value: DepartmentEntity)
//        newBusiness.addToEmployees(<#T##value: EmployeeEntity##EmployeeEntity#>)
        save()
    }
    
    func addDepartment() {
        let newDepartment = DepartmentEntity(context: manager.context)
        newDepartment.name = "app" // come from params usually
//        newDepartment.businesses = [businesses[0]] // to many is a NSSet
//        newDepartment.employees = [employees[1]]
        // do not forget save
        save()
    }
    
    func addEmployee() {
        let newEmployee = EmployeeEntity(context: manager.context)
        newEmployee.age = 99
        newEmployee.dateJoined = Date()
        newEmployee.name = "Emely"
        
        
        save()
    }
    
    func updateBusiness() {
        let existingBussiness = businesses[0]
        existingBussiness.addToDepartments(departments[1])
        save()
    }
    
    func deleteDepartment(){
        let department = departments[0] // pass as params
        manager.context.delete(department)
        save()
    }
    
    func deleteAllData() {
        let businessFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BusinessEntity")
        let businessDeleteRequest = NSBatchDeleteRequest(fetchRequest: businessFetchRequest)

        let departmentFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DepartmentEntity")
        let departmentDeleteRequest = NSBatchDeleteRequest(fetchRequest: departmentFetchRequest)

        let employeeFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeEntity")
        let employeeDeleteRequest = NSBatchDeleteRequest(fetchRequest: employeeFetchRequest)

        do {
            try manager.context.execute(businessDeleteRequest)
            try manager.context.execute(departmentDeleteRequest)
            try manager.context.execute(employeeDeleteRequest)

            save()

            getBusinesses()
            getDepartments()
            getEmployees()

        } catch {
            print("Error deleting data: \(error.localizedDescription)")
        }
    }
    
    
    func save (){
        businesses.removeAll()
        departments.removeAll()
        employees.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ) {
            self.manager.save()
            self.getBusinesses()
            self.getDepartments()
            self.getEmployees()
        }
        
//        manager.save()
//        getBusinesses()
    }
    
    
}

class CoreDataManager {
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "CoreDataContainer")
        container.loadPersistentStores{ (description, error) in
            if let error = error {
                print("Error loading Core Data. \(error)")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do {
          try context.save()
            print("saved")
        } catch let error {
            print("save error \(error.localizedDescription)")
        }
    }
    
    
}
