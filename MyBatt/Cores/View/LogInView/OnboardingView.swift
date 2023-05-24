//
//  LogInView.swift
//  MyBatt
//r
//  Created by 김태윤 on 2023/05/19.
//

enum SignType:String, Identifiable{
    var id: String{
        self.rawValue
    }
    case signUp
    case signIn
}

import SwiftUI
struct OnboardingView: View {
    @EnvironmentObject var appManager: AppManager
    @EnvironmentObject var userVM: UserVM
    @State private var emailInput = ""
    @State private var passwordInput = ""
    @State private var isPresented = false
    @State private var signType:SignType? = nil
    @State private var isLoggedIn = false
    @State private var isAnimating = false
    var body: some View {
        VStack(spacing:0){
            ScrollView{
                VStack(spacing:18){
                    VStack(alignment:.leading,spacing:18){
                        HStack{
                            Text("로그인하고\n작물을 진단 해보세요.")
                            Spacer()
                        }
                        .font(.system(.largeTitle).bold())
                        Text("로그인이 필요한 서비스입니다.")
                            .font(.title3)
                            .foregroundColor(Color.secondary.opacity(1.2))
                            .bold()
                    }.padding()
                    Spacer()
                    self.onboardView
//                    Spacer()
//                    Spacer()
                }
                .padding()
            }
            Spacer()
            VStack{
                HStack(spacing:8){
                    Spacer()
                    ImageAppeaerBtnView(btnAction:{
                        self.signType = .signUp
                    },labelText: "회원가입", iconName: "person.badge.plus", bgColor: .accentColor)
                    Spacer()
                    ImageAppeaerBtnView(btnAction:{
                        //                            withAnimation {
                        //                                appManager.isLoginActive = true
                        //                            }
                        self.signType = .signIn
                    },labelText: "로그인", iconName: "person.badge.key", bgColor: .blue)
                    Spacer()
                }
                .padding(.bottom)
            }
        }
        .opacity(isAnimating ? 1 : 0)
        .sheet(item: $signType, content: { signType in
            switch signType{
            case .signUp: SignUpSheetView().environmentObject(userVM)
                    .onDisappear(){
                        self.signType = nil
                    }
            case .signIn: SignInSheetView().environmentObject(userVM)
                    .onDisappear(){
                        self.signType = nil
                    }
            }
        })
        .presentationDetents([.height(CGFloat(signType == .signUp ? 500 : 360))])
        .sheetColor(.white)
        .edgeAttachedInCompactHeight(true)
        .scrollingExpandsWhenScrolledToEdge(true)
        .widthFollowsPreferredContentSizeWhenEdgeAttached(true)
        .onReceive(userVM.loginSuccess) { _ in
//            print("LogIn - loginSuccessCalled()")
            print("isLoggedIn",userVM.isUserLoggined)
            print("loggedInUserKey:")
            isLoggedIn.toggle()
        }
        .alert(isPresented: $isLoggedIn) {
            Alert(title:Text("IsLoggedIn"))
        }
        .onAppear(){
            withAnimation{
                isAnimating.toggle()
            }
        }
        .onDisappear(){
            withAnimation {
                isAnimating.toggle()
            }
        }
    }
    var onboardView: some View{
        let items = ["작물 이미지를 촬영하여 병해 진단하기","내 주변 병해 발생 지도 보기","작물 진단 기록 관리","진단 결과에 대해 궁금한 점을 전문가에게\n질문하기"]
        return VStack(spacing:48){
            Image("logo_demo").resizable()
                .frame(width: appManager.screenWidth/2,height: appManager.screenWidth/2)
            VStack(alignment: .leading,spacing:8){
                ForEach(items,id:\.self){ str in
                    onboardItemView(str)
                }
            }
        }
    }
    func onboardItemView(_ str:String)-> some View{
        HStack(){
            Image(systemName: "checkmark.circle")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .background(Circle().foregroundColor(.accentColor.opacity(0.15)))
            Text(str).font(.system(size: 18,weight: .medium, design: .rounded))
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView().environmentObject(AppManager())
    }
}
