//
//  Model.swift
//  ReactiveUIExample
//
//  Created by Bartosz Dolewski on 02.02.2018.
//  Copyright © 2018 objc.io. All rights reserved.
//

import Foundation
import RxSwift

class Model {
    let webservice = Webservice()
    let countriesDataSource = CountriesDataSource()
    let disposeBag = DisposeBag()
    
    var vatSignal: Observable<Optional<Double>> {
        get {
            return countriesDataSource.selectedIndex.asObservable()
                .distinctUntilChanged()
                .map { [unowned self] index in
                    self.countriesDataSource.countries[index].lowercased() }
                .flatMap { [unowned self] country in
                    self.webservice.load(vat(country: country)).map { Optional.some($0)}.startWith(nil) }
                .shareReplay(1)
        }
    }
}
