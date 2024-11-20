//
//  StructToDo.swift
//  ToDoList
//
//  Created by Kristofer Sartorial on 11/15/24.
//

import Foundation
struct ToDo: Codable {
    var id: UUID
    var title:String
    var description: String
    var createdDate: Date
    var isCompleted: Bool
}
