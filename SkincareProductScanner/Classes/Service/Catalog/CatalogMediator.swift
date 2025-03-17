//
//  CatalogMediator.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 17.03.2025.
//

import RxSwift
import RxCocoa

final class CatalogMediator {
    static let shared = CatalogMediator()
    
    private lazy var didSaveGlossaryIdTrigger = PublishRelay<String>()
    private lazy var didUnsaveGlossaryIdTrigger = PublishRelay<String>()
    private lazy var didSaveProcedureIdTrigger = PublishRelay<String>()
    private lazy var didUnsaveProcedureIdTrigger = PublishRelay<String>()
    
    private init() {}
}

// MARK: Public
extension CatalogMediator {
    func saveGlossary(id: String) {
        DispatchQueue.main.async {
            Self.shared.didSaveGlossaryIdTrigger.accept(id)
        }
    }
    
    func unsaveGlossary(id: String) {
        DispatchQueue.main.async {
            Self.shared.didUnsaveGlossaryIdTrigger.accept(id)
        }
    }
    
    func saveProcedure(id: String) {
        DispatchQueue.main.async {
            Self.shared.didSaveProcedureIdTrigger.accept(id)
        }
    }
    
    func unsaveProcedure(id: String) {
        DispatchQueue.main.async {
            Self.shared.didUnsaveProcedureIdTrigger.accept(id)
        }
    }
    
    var didSaveGlossaryId: Signal<String> {
        didSaveGlossaryIdTrigger.asSignal()
    }
    
    var didUnsaveGlossaryId: Signal<String> {
        didUnsaveGlossaryIdTrigger.asSignal()
    }
    
    var didSaveProcedureId: Signal<String> {
        didSaveProcedureIdTrigger.asSignal()
    }
    
    var didUnsaveProcedureId: Signal<String> {
        didUnsaveProcedureIdTrigger.asSignal()
    }
}
