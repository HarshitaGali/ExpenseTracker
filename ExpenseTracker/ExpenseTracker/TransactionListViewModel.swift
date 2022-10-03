//
//  TransactionListViewModel.swift
//  ExpenseTracker
//
//  Created by Harshita Gali on 30/09/2022.
//

import Foundation
import Combine
import Collections

final class TransactionListViewModel : ObservableObject {
    @Published var transactions : [Transaction] = []
    typealias TransactionGroup = OrderedDictionary<String,[Transaction]>
    typealias TransactionPrefixSum = [(String , Double)]
    
    private var cancellbles = Set<AnyCancellable>()
    init(){
        getTransaction()
    }
    
    func getTransaction(){
        //URL
        guard let url = URL(string : "https://designcode.io/data/transactions.json") else {
            print("Invalid URL")
            return
        }
        //DataTaskPublisher
         URLSession.shared.dataTaskPublisher(for: url)
        //TryMap()
            .tryMap { (data,response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200 else{
                    dump(response)
                    throw URLError(.badServerResponse)
                }
                return data
            }
        //Decode
            .decode(type: [Transaction].self, decoder: JSONDecoder())
        //Receive
            .receive(on: DispatchQueue.main)
        //Sink
            .sink(receiveCompletion: {(completion) in
                switch completion {
                case.failure(let error):
                    print("Error fetching transactions:", error.localizedDescription)
                case .finished:
                    print("Finished fetching transactions")
                }
            }, receiveValue: {
                [weak self] result in self?.transactions = result
                    dump(self?.transactions as Any)
            })
        //Store
            .store(in: &cancellbles)
    }
 
    
    func groupTransactionsByMonth() -> TransactionGroup{
        //check if transactions are empty
        guard !transactions.isEmpty else{return[:]}
        
        let groupedTransactions = TransactionGroup(grouping: transactions){$0.month}
        return groupedTransactions
    }
    
    func accumulateTransaction() -> TransactionPrefixSum{
        print("accumulate transactions")
        guard !transactions.isEmpty else {
            return [] }
        let today  = "03/10/2022".dateParsed()
        let dateInterval = Calendar.current.dateInterval(of: .month, for: today)!
        print(dateInterval)
        var sum:Double = .zero
        var cumulativeSum = TransactionPrefixSum()
        
        for date in stride(from: dateInterval.start, to: today, by: 60 * 60 * 24){
            let dailyExpenses = transactions.filter{$0.dateParsed == date && $0.isExpense }
            let dailyTotal = dailyExpenses.reduce(0) { $0 - $1.signedAmount}
            sum += dailyTotal
            sum = sum.roundedTo2Digits()
            cumulativeSum.append((date.formatted(), sum))
            print(date.formatted(),dailyTotal , sum)
        }
        return cumulativeSum
    }
}

