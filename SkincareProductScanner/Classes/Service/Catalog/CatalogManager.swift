//
//  CatalogManager.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 17.03.2025.
//

import RxSwift
import RxCocoa

protocol CatalogManagerProtocol {
    func obtainGlossaries(forceUpdate: Bool) -> Single<[Catalog]>
    func obtainProcedures(forceUpdate: Bool) -> Single<[Catalog]>
    func obtainGlossaryDetails(id: String) -> Single<CatalogDetails?>
    func obtainProcedureDetails(id: String) -> Single<CatalogDetails?>
    func saveGlossary(id: String) -> Single<RequestResult>
    func saveProcedure(id: String) -> Single<RequestResult>
    func unsaveGlossary(id: String) -> Single<RequestResult>
    func unsaveProcedure(id: String) -> Single<RequestResult>
    func obtainBookmarksGlossaries() -> Single<[Catalog]>
    func obtainBookmarksProcedures() -> Single<[Catalog]>
}

final class CatalogManager {
    enum Constants {
        static let glossariesKey = "catalog_manager_glossaries_key"
        static let proceduresKey = "catalog_manager_procedures_key"
    }
    
    private lazy var sessionManager = SessionManager()
    
    private lazy var restAPITransport = RestAPITransport()
}

// MARK: CatalogManagerProtocol
extension CatalogManager: CatalogManagerProtocol {
    func obtainGlossaries(forceUpdate: Bool) -> Single<[Catalog]> {
        if forceUpdate {
            let request = GetGlossariesRequest(
                anonymousId: sessionManager.anonymousId,
                internalId: sessionManager.internalId
            )
            return loadCatalogs(request: request, storageKey: Constants.glossariesKey)
        } else {
            return cachedCatalogs(storageKey: Constants.glossariesKey)
        }
    }
    
    func obtainProcedures(forceUpdate: Bool) -> Single<[Catalog]> {
        if forceUpdate {
            let request = GetProceduresRequest(
                anonymousId: sessionManager.anonymousId,
                internalId: sessionManager.internalId
            )
            return loadCatalogs(request: request, storageKey: Constants.proceduresKey)
        } else {
            return cachedCatalogs(storageKey: Constants.proceduresKey)
        }
    }
    
    func obtainGlossaryDetails(id: String) -> Single<CatalogDetails?> {
        let request = GetGlossaryDetailsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { CatalogDetails(response: $0) }
    }
    
    func obtainProcedureDetails(id: String) -> Single<CatalogDetails?> {
        let request = GetProcedureDetailsRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { CatalogDetails(response: $0) }
    }
    
    func saveGlossary(id: String) -> Single<RequestResult> {
        let request = SaveGlossaryRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                CatalogMediator.shared.saveGlossary(id: id)
            })
    }
    
    func saveProcedure(id: String) -> Single<RequestResult> {
        let request = SaveProcedureRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                CatalogMediator.shared.saveProcedure(id: id)
            })
    }
    
    func unsaveGlossary(id: String) -> Single<RequestResult> {
        let request = UnsaveGlossaryRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                CatalogMediator.shared.unsaveGlossary(id: id)
            })
    }
    
    func unsaveProcedure(id: String) -> Single<RequestResult> {
        let request = UnsaveProcedureRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId,
            id: id
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { RequestResult.map(response: $0) }
            .do(onSuccess: { result in
                guard result.success else { return }
                
                CatalogMediator.shared.unsaveProcedure(id: id)
            })
    }
    
    func obtainBookmarksGlossaries() -> Single<[Catalog]> {
        let request = GetBookmarksGlossariesRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { Catalog.map(response: $0) }
    }
    
    func obtainBookmarksProcedures() -> Single<[Catalog]> {
        let request = GetBookmarksProceduresRequest(
            anonymousId: sessionManager.anonymousId,
            internalId: sessionManager.internalId
        )
        
        return restAPITransport
            .callServerApi(requestBody: request)
            .map { Catalog.map(response: $0) }
    }
}

// MARK: Private
private extension CatalogManager {
    func loadCatalogs(request: APIRequestBody, storageKey: String) -> Single<[Catalog]> {
        restAPITransport
            .callServerApi(requestBody: request)
            .map { Catalog.map(response: $0) }
            .do(onSuccess: { catalogs in
                guard let data = try? JSONEncoder().encode(catalogs) else { return }
                
                UserDefaults.standard.set(data, forKey: storageKey)
            })
    }
    
    func cachedCatalogs(storageKey: String) -> Single<[Catalog]> {
        Single<[Catalog]>.create { event in
            let catalogs: [Catalog] = {
                guard
                    let data = UserDefaults.standard.data(forKey: storageKey),
                    let catalogs = try? JSONDecoder().decode([Catalog].self, from: data)
                else { return [] }
                
                return catalogs
            }()

            event(.success(catalogs))

            return Disposables.create()
        }
    }
}
