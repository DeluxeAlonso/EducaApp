//
//  Payment.swift
//  EducaApp
//
//  Created by Alonso on 11/6/15.
//  Copyright © 2015 Alonso. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

let PaymentEntityName = "Payment"
let PaymentIdKey = "fee_id"
let PaymentDueDate = "due_date"
let PaymentFeeNumberKey = "fee_number"
let PaymentStatusKey = "status"
let PaymentAmountKey = "amount"

@objc(Payment)
public class Payment: NSManagedObject {

    @NSManaged public var id: Int32
    @NSManaged public var status: Int32
    @NSManaged public var dueDate: NSDate
    @NSManaged public var amount: Float
    @NSManaged public var feeNumber: Int32

}

// MARK: - JSON Deserialization

extension Payment: Deserializable {
  
  func setDataFromJSON(json: NSDictionary) {
    guard let id = json[PaymentIdKey] as AnyObject?, feeNumber = json[PaymentFeeNumberKey] as AnyObject?, date = json[PaymentDueDate] as? Double, amount = json[PaymentAmountKey] as? Float, status = json[PaymentStatusKey] as AnyObject? else {
      return
    }
    self.id = id is Int ? Int32(id as! Int) : Int32(id as! String)!
    self.status = status is Int ? Int32(status as! Int) : Int32(status as! String)!
    self.feeNumber = feeNumber is Int ? Int32(feeNumber as! Int) : Int32(feeNumber as! String)!
    self.amount = amount
    self.dueDate = NSDate(timeIntervalSince1970: date)
  }
  
}

// MARK: - CoreData

extension Payment {
  
  public class func syncWithJsonArray(arr: Array<NSDictionary>, ctx: NSManagedObjectContext) -> Array<Payment> {
    // Map JSON to ids, for easier access
    var jsonById = Dictionary<Int, NSDictionary>()
    for json in arr {
      if let id = json[PaymentIdKey] as AnyObject? {
        let paymentsId = id is Int ? id as! Int : Int(id as! String)!
        jsonById[paymentsId] = json
      }
    }
    let ids = Array(jsonById.keys)
    
    // Get persisted articles
    let persistedPayments = Payment.getAllPayments(ctx)
    var persistedPaymentById = Dictionary<Int, Payment>()
    for art in persistedPayments {
      persistedPaymentById[Int(art.id)] = art
    }
    let persistedIds = Array(persistedPaymentById.keys)
    
    // Create new objects for new ids
    let newIds = NSMutableSet(array: ids)
    newIds.minusSet(NSSet(array: persistedIds) as Set<NSObject>)
    let newPayments = newIds.allObjects.map({ (id: AnyObject) -> Payment in
      let newPayment = NSEntityDescription.insertNewObjectForEntityForName(PaymentEntityName, inManagedObjectContext: ctx) as! Payment
      newPayment.id = (Int32(id as! Int))
      return newPayment
    })
    
    // Find existing objects
    let updateIds = NSMutableSet(array: ids)
    updateIds.intersectSet(NSSet(array: persistedIds) as Set<NSObject>)
    let updatePayments = updateIds.allObjects.map({ (id: AnyObject) -> Payment in
      return persistedPaymentById[id as! Int]!
    })
    
    // Apply json to each
    let validPayments = newPayments + updatePayments
    for payment in validPayments {
      Payment.updateOrCreateWithJson(jsonById[Int(payment.id)]!,ctx: ctx)
    }
    
    // Delete old items
    let deleteIds = NSMutableSet(array: persistedIds)
    deleteIds.minusSet(NSSet(array: ids) as Set<NSObject>)
    let deletePayments = deleteIds.allObjects.map({ (id: AnyObject) -> Payment in
      return persistedPaymentById[id as! Int]!
    })
    for payment in deletePayments {
      ctx.deleteObject(payment)
    }
    
    return Payment.getAllPayments(ctx)
  }
  
  class func findOrCreateWithId(id: Int32, ctx: NSManagedObjectContext) -> Payment {
    var payment: Payment? = getPaymentById(id, ctx: ctx)
    if (payment == nil) {
      payment = NSEntityDescription.insertNewObjectForEntityForName(PaymentEntityName, inManagedObjectContext: ctx) as? Payment
    }
    return payment!
  }
  
  class func getPaymentById(id: Int32, ctx: NSManagedObjectContext) -> Payment? {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(PaymentEntityName, inManagedObjectContext: ctx)
    fetchRequest.predicate = NSPredicate(format: "(id = %d)", Int(id))
    let payments = try! ctx.executeFetchRequest(fetchRequest) as? Array<Payment>
    if (payments != nil && payments!.count > 0) {
      return payments![0]
    }
    return nil
  }
  
  class func updateOrCreateWithJson(json: NSDictionary, ctx: NSManagedObjectContext) -> Payment? {
    var payment: Payment?
    if let id = json[PaymentIdKey] as AnyObject?  {
      let paymentId = id is Int ? Int32(id as! Int) : Int32(id as! String)!
      payment = findOrCreateWithId(paymentId, ctx: ctx)
      payment?.setDataFromJSON(json)
    }
    return payment
  }
  
  class func getAllPayments(ctx: NSManagedObjectContext) -> Array<Payment> {
    let fetchRequest = NSFetchRequest()
    fetchRequest.entity = NSEntityDescription.entityForName(PaymentEntityName, inManagedObjectContext: ctx)
    let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let payments = try! ctx.executeFetchRequest(fetchRequest) as? Array<Payment>
    
    return payments ?? Array<Payment>()
  }
  
}
