//
//  CM_MainVM.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/07.
//

import Foundation
import Combine
import Alamofire
final class CM_MainVM: ObservableObject{
    @Published var cm_GroupList: [CM_GroupListItem] = []
    @Published var unclassfiedGroup: CM_GroupListItem = .init(id: 0, userID: nil, name: "", cnt: nil, memo: "", regDt: "")
    var addCompleted = PassthroughSubject<Void,Never>()
    var deleteCompleted = PassthroughSubject<Int,Never>()
    var goToNextView = PassthroughSubject<(String,Int),Never>()
    var goEditView = PassthroughSubject<GroupSettingType,Never>()
    var subscription = Set<AnyCancellable>()
    init(){
        self.getList()
    }
    deinit{
        self.subscription.forEach { can in
            can.cancel()
        }
    }
    func getList(){
        ApiClient.shared.session.request(CM_Router.CM_List,interceptor: AuthAuthenticator.getAuthInterceptor)
            .publishDecodable(type: ResponseWrapper<[CM_GroupListItem]>.self)
            .value()
            .sink(receiveCompletion: { completion in
                switch completion{
                case .finished:
                    print("가져오기 성공")
                case .failure(let error):
                    print("가져오기 실패")
                    print(error.localizedDescription)
                }
            }, receiveValue: {[weak self] output in
                guard let response: [CM_GroupListItem] = output.data else { return }
                self?.cm_GroupList = response.filter { item in
                    if item.name == "unclassified"{
                        self?.unclassfiedGroup = item
                        return false
                    }
                    return true
                }
            }).store(in: &subscription)
    }
    func addGroup(name: String,memo:String){
        ApiClient.shared.session.request(CM_Router.CM_GroupCreate(name: name),
                                         interceptor: AuthAuthenticator.getAuthInterceptor)
            .publishDecodable(type: ResponseWrapper<CM_GroupListItem>.self)
            .value()
            .sink(receiveCompletion: { completion in
                switch completion{
                case .finished:
                    print("가져오기 성공")
                case .failure(let error):
                    print("가져오기 실패")
                    print(error.localizedDescription)
                }
            }, receiveValue: {[weak self] output in
                guard let response: CM_GroupListItem = output.data else { return }
                self?.addCompleted.send()
            }).store(in: &subscription)
    }
    func editGroup(id:Int,newName:String,newMemo:String){
        print("editGroup 함수 입력!!")
        print(id,newName,newMemo)
        ApiClient.shared.session.request(CM_Router.CM_GroupUpdate(id: id, newName: newName, newMemo: newMemo),
                                         interceptor: AuthAuthenticator.getAuthInterceptor)
        .publishDecodable(type: ResponseWrapper<CM_GroupListItem>.self)
            .value()
            .sink(receiveCompletion: { completion in
                switch completion{
                case .finished:
                    print("가져오기 성공")
                case .failure(let error):
                    print("가져오기 실패")
                    print(error.localizedDescription)
                }
            }, receiveValue: {[weak self] output in
                print("성공적인 변경!!")
                self?.addCompleted.send()
            }).store(in: &subscription)
    }
    func deleteGroup(id:Int,idx:Int){
        ApiClient.shared.session.request(CM_Router.CM_GroupDelete(id: id),
                                         interceptor: AuthAuthenticator.getAuthInterceptor)
        .publishDecodable(type: ResponseWrapper<CM_GroupListItem>.self)
            .value()
            .sink(receiveCompletion: { completion in
                switch completion{
                case .finished:
                    print("가져오기 성공")
                case .failure(let error):
                    print("가져오기 실패")
                    print(error.localizedDescription)
                }
            }, receiveValue: {[weak self] output in
                self?.deleteCompleted.send(idx)
            }).store(in: &subscription)
    }
    func getMainViewGroupListInfo()->[(String,Int)]{
        var list = [(self.unclassfiedGroup.name,self.unclassfiedGroup.cnt ?? 0)]
        for v in self.cm_GroupList{
            list.append((v.name,v.cnt ?? 0))
        }
        return list
    }
    func getGroupDialogeList()->[CM_GroupModel]{
        var list:[CM_GroupModel] = [.init(groupId: self.unclassfiedGroup.id, name: self.unclassfiedGroup.name)]
        for v in self.cm_GroupList{
            list.append(.init(groupId: v.id, name: v.name))
        }
        return list
    }
}
