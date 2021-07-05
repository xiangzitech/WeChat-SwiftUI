import SwiftUI
import SwiftUIRedux
import URLImage

/* TODO:
 1. 因为暂时无法改变 grouped list 的 footer 的高度，所以 SectionHeader 使用 cell 代替
 2. 去除 UserInfo cell 的点击效果
 */

struct MeView: ConnectedView {
  struct Props {
    let userSelf: Loadable<User>
    let loadUserSelf: () -> Void
  }

  func map(state: AppState, dispatch: @escaping (Action) -> Void) -> Props {
    Props(
      userSelf: state.meState.userSelf,
      loadUserSelf: { dispatch(MeActions.LoadUserSelf()) }
    )
  }

  func body(props: Props) -> some View {
    NavigationView {
      content(props)
      .navigationBarHidden(true)
    }
  }
}

// MARK: - Display Content
private extension MeView {

  private func content(_ props: Props) -> some View {
    switch props.userSelf {
    case .notRequested:
      return AnyView(Text("").onAppear(perform: props.loadUserSelf))

    case let .isLoading(last, _):
      return AnyView(loadingView(me: last))

    case let .loaded(userSelf):
      return AnyView(loadedView(me: userSelf, showLoading: false))

    case let .failed(error):
      return AnyView(ErrorView(error: error, retryAction: props.loadUserSelf))
    }
  }

  func loadingView(me previouslyLoaded: User?) -> some View {
    if let me = previouslyLoaded {
      return AnyView(loadedView(me: me, showLoading: true))
    } else {
      return AnyView(ActivityIndicatorView().padding())
    }
  }

  func loadedView(me: User, showLoading: Bool) -> some View {
    ZStack(alignment: .topTrailing) {
      ZStack {
        List {
          Section {
            MeInfo(me: me)
          }
          .listRowBackground(Color.app_white)

          SectionHeader()

          Section {
            MeItemRow(item: .pay)
          }
          .listRowBackground(Color.app_white)

          SectionHeader()

          Section {
            ForEach([MeItem.favorites, MeItem.stickerGallery], id: \.self) {
              MeItemRow(item: $0)
            }
          }
          .listRowBackground(Color.app_white)

          SectionHeader()

          Section {
            MeItemRow(item: .settings)
          }
          .listRowBackground(Color.app_white)
        }
        .environment(\.defaultMinListRowHeight, 10)
        .listStyle(PlainListStyle())

        if showLoading {
          ActivityIndicatorView(color: .gray)
            .padding()
        }
      }

      Image("icons_filled_camera")
        .padding(.top, 4)
        .padding(.trailing, 14)
    }
  }
}

// MARK: - Helper Types
extension MeView {
  func MeInfo(me: User) -> some View {
    ZStack(alignment: .leading) {
      NavigationLink(destination: Text("Profile")) {
        EmptyView()
      }
      .opacity(0.0) // 为了隐藏 NavigationLink 右边的箭头

      HStack(spacing: 16) {
        if let url = URL(string: me.avatar) {
          URLImage(
            url,
            empty: { avatarPlaceholder },
            inProgress: { _ in avatarPlaceholder },
            failure: { _, _ in avatarPlaceholder },
            content: { image in
              image
                .resizeToFill()
                .frame(width: 64, height: 64)
            })
            .background(Color.app_bg)
            .cornerRadius(6)
        }

        VStack(alignment: .leading, spacing: 5) {
          Text(me.name)
            .foregroundColor(.text_primary)
            .font(.system(size: 20, weight: .semibold))

          HStack(spacing: 2) {
            Text("\(Strings.general_wechat_id()): \(me.wechatId)")
              .font(.system(size: 14))
            Image("icons_outlined_qr_code")
              .resizeToFill()
              .frame(width: 14, height: 14)
            Spacer()
            Image(systemName: "chevron.right")
              .font(.system(size: 14, weight: .medium))
          }
          .foregroundColor(.text_info_200)
        }
      }
      .padding(.vertical, 30)
    }
  }

  var avatarPlaceholder: some View {
    Image.avatarPlaceholder
      .resizeToFill()
      .foregroundColor(.app_bg)
      .frame(width: 64, height: 64)
  }

  func MeItemRow(item: MeItem) -> some View {
    NavigationLink(
      destination: Text(item.title),
      label: {
        HStack {
          item.iconImage
            .frame(width: 24, height: 24)
          Text(item.title)
            .foregroundColor(.text_primary)
            .font(.system(size: 16))
        }
      })
      .frame(height: 44)
  }

  func SectionHeader() -> some View {
    Color.app_bg
      .listRowInsets(.zero)
      .frame(height: 10)
  }
}

extension MeView {
  enum MeItem {
    case pay
    case favorites
    case stickerGallery
    case settings

    var title: String {
      switch self {
      case .pay: return Strings.me_pay()
      case .favorites: return Strings.me_favorites()
      case .stickerGallery: return Strings.me_sticker_gallery()
      case .settings: return Strings.me_settings()
      }
    }

    var iconImage: some View {
      switch self {
      case .pay:
        return AnyView(Image("icons_outlined_wechatpay"))
      case .favorites:
        return AnyView(Image("icons_outlined_colorful_favorites"))
      case .stickerGallery:
        return AnyView(
          Image("icons_outlined_sticker")
            .foregroundColor(.hex("F5C343"))
        )
      case .settings:
        return AnyView(
          Image("icons_outlined_setting")
            .foregroundColor(.hex("3C86E6"))
        )
      }
    }
  }
}

struct MeView_Previews: PreviewProvider {
  static var previews: some View {
    MeView()
  }
}