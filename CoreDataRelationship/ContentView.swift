//
//  ContentView.swift
//  CoreDataRelationship
//
//  Created by Feihuan Peng on 3/9/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = CoreDataRelationshipViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(spacing: 20) {
                    
                    Button(action: {
                        vm.deleteDepartment()
                    }, label: {
                        Text("Perform Action")
                            .foregroundStyle(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.cornerRadius(10))
                    })

                    Button(action: {
                        vm.deleteAllData()
                    }, label: {
                        Text("Start Over")
                            .foregroundStyle(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.red.cornerRadius(10))
                    })

                    
                    ScrollView(.horizontal, showsIndicators: true, content: {
                        HStack(alignment: .top) {
                            ForEach(vm.businesses) {business in
                                    BusinessView(entity: business)
                            }
                        }
                    })
                    
                    ScrollView(.horizontal, showsIndicators: true, content: {
                        HStack(alignment: .top) {
                            ForEach(vm.departments) {department in
                                    DepartmentView(entity: department)
                            }
                        }
                    })        
                    
                    ScrollView(.horizontal, showsIndicators: true, content: {
                        HStack(alignment: .top) {
                            ForEach(vm.employees) {employee in
                                    EmployeeView(entity: employee)
                            }
                        }
                    })
                    
                }
                .padding()
            }
            .navigationTitle("Relashionships")
        }
    }
}

struct BusinessView: View {
    
    let entity: BusinessEntity
    
    var body: some View {
        VStack(alignment: .leading,spacing: 20, content: {
            Text("Name: \(entity.name ?? "default")")
                .bold()
            
            if let departments = entity.departments?.allObjects as? [DepartmentEntity] {
                Text("Departments:")
                    .bold()
                ForEach(departments) {department in
                    Text(department.name ?? "defaut")
                }
            }            
            if let employees = entity.employees?.allObjects as? [EmployeeEntity] {
                Text("employees:")
                    .bold()
                ForEach(employees) {employee in
                    Text(employee.name ?? "defaut")
                }
            }
        })
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.gray.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct DepartmentView: View {
    
    let entity: DepartmentEntity
    
    var body: some View {
        VStack(alignment: .leading,spacing: 20, content: {
            Text("Name: \(entity.name ?? "default")")
                .bold()
            
            if let businesses = entity.businesses?.allObjects as? [BusinessEntity] {
                Text("Bussinesses:")
                    .bold()
                ForEach(businesses) {business in
                    Text(business.name ?? "defaut")
                }
            }
            if let employees = entity.employees?.allObjects as? [EmployeeEntity] {
                Text("employees:")
                    .bold()
                ForEach(employees) {employee in
                    Text(employee.name ?? "defaut")
                }
            }
        })
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.green.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct EmployeeView: View {
    
    let entity: EmployeeEntity
    
    var body: some View {
        VStack(alignment: .leading,spacing: 20, content: {
            Text("Name: \(entity.name ?? "default")")
                .bold()
            Text("Age: \(entity.age)")
            Text("Date joined: \(entity.dateJoined ?? Date())")
            Text("Bussiness:")
                .bold()
            Text(entity.business?.name ?? "");
            Text("Department:")
                .bold()
            Text(entity.department?.name ?? "")
      
        })
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.blue.opacity(0.5))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}


#Preview {
    ContentView()
}
