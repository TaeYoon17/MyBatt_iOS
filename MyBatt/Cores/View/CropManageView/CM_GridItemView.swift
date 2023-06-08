//
//  CM_GridItemView.swift
//  MyBatt
//
//  Created by 김태윤 on 2023/06/04.
//

import SwiftUI

struct CM_GridItemView: View {
    @Binding var isEditting: Bool
    @Binding var item: CM_GroupListItem
    @EnvironmentObject var vm: CM_MainVM
    let color: Color
    var isUnclassfied: Bool = false
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.lightGray)
            .aspectRatio(1,contentMode: .fit)
            .overlay(alignment:.top){
                Button{
                    if isEditting{
                        if !isUnclassfied{
                            vm.goEditView.send(.Edit(id: item.id, name: item.name, memo: item.memo))
                        }
                    }else{
                        vm.goToNextView.send((item.name,item.id))
                    }
                }label:{
                    GroupBox {
                        VStack(alignment:.leading){
                            Divider()
                            if isUnclassfied{
                                Text("병해 진단 후 카테고리가 설정되지 않은 작물들입니다.")
                                    .font(Font.callout)
                                    .multilineTextAlignment(.leading)
                            }else{
                                Text(item.memo)
                                    .font(Font.callout)
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                        }
                    } label: {
                        HStack{
                            
                            if isUnclassfied{
                                Text("미분류 그룹 (\(item.cnt ?? 0))")
                                    .font(.subheadline.weight(.semibold))
                            }else{
                                Text("\(item.name) (\(item.cnt ?? 0))").font(.subheadline.weight(.semibold))
                            }
                            
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .imageScale(.small)
                        }
                    }
                }.groupBoxStyle(GroupBoxBackGround(color:color))
                    .foregroundColor(.black)
                
            }
        
        
    }
}
struct CM_GridItemView_Previews: PreviewProvider {
    static var previews: some View {
        CM_MainView().environmentObject(AppManager())
    }
}
