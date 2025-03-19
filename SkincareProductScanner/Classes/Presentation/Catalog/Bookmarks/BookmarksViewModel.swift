//
//  BookmarksViewModel.swift
//  SkincareProductScanner
//
//  Created by Андрей Чернышев on 18.03.2025.
//

import RxSwift
import RxCocoa

final class BookmarksViewModel {}

// MARK: Public
extension BookmarksViewModel {
    struct Input {
        let didSelectEntity: Signal<BookmarksEntityButton.Entity>
    }
    
    struct Output {
        let currentEntity: Driver<BookmarksEntityButton.Entity>
    }
    
    func configure(input: Input) -> Output {
        Output(
            currentEntity: makeCurrentEntity(didSelectEntity: input.didSelectEntity)
        )
    }
}

// MARK: Private
private extension BookmarksViewModel {
    func makeCurrentEntity(didSelectEntity: Signal<BookmarksEntityButton.Entity>) -> Driver<BookmarksEntityButton.Entity> {
        didSelectEntity
            .asDriver(onErrorDriveWith: .never())
            .startWith(.products)
    }
}
