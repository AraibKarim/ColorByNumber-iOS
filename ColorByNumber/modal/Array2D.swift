//
//  Array2D.swift
//  CookieCrunch
//
//  Created by Razeware on 13/04/16.
//  Copyright © 2018 WoodyApps. All rights reserved.
//
struct Array2D<T> {
  
  let columns: Int
  let rows: Int
  fileprivate var array: Array<T?>
  
  init(columns: Int, rows: Int) {
    self.columns = columns
    self.rows = rows
    array = Array<T?>(repeating: nil, count: rows*columns)
  }
  
  subscript(column: Int, row: Int) -> T? {
    get {
      return array[row*columns + column]
    }
    set {
      array[row*columns + column] = newValue
    }
  }
  
}
