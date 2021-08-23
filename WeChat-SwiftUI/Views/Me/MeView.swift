import SwiftUI
import SwiftUIRedux
import URLImage

/* TODO:
--- 因为暂时无法改变 header 的高度，所以 SectionHeader 使用 cell 代替
--- 去除 UserInfo cell 的点击效果
 */

struct MeView: ConnectedView {
  struct Props {
    let signedInUser: User?
  }

  func map(state: AppState, dispatch: @escaping (Action) -> Void) -> Props {
    Props(
      signedInUser: state.authState.signedInUser
    )
  }

  func body(props: Props) -> some View {
    NavigationView {
      content(props)
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
    .navigationViewStyle(.stack)
  }
}

// MARK: - Display Content
private extension MeView {

  func content(_ props: Props) -> some View {
    if let user = props.signedInUser {
      return AnyView(Me(user))
    } else {
      return AnyView(EmptyView())
    }
  }

  func Me(_ me: User) -> some View {
    ZStack(alignment: .topTrailing) {
      List {
        Section {
          MyInfoRow(me: me)
        }
        .listRowBackground(Color.app_white)

        SectionHeaderBackground()

        Section {
          MeItemRow(item: .pay)
        }
        .listRowBackground(Color.app_white)

        SectionHeaderBackground()

        Section {
          ForEach([MeItem.favorites, MeItem.stickerGallery], id: \.self) {
            MeItemRow(item: $0)
          }
        }
        .listRowBackground(Color.app_white)

        SectionHeaderBackground()

        Section {
          MeItemRow(item: .settings)
        }
        .listRowBackground(Color.app_white)
      }
      .background(.app_bg)
      .listStyle(.plain)
      .environment(\.defaultMinListRowHeight, 10)

      Image("icons_filled_camera")
        .padding(.top, 4)
        .padding(.trailing, 14)
    }
  }
}

// MARK: - Helper Types
extension MeView {
  func MyInfoRow(me: User) -> some View {
    ZStack(alignment: .leading) {
      NavigationLink(destination: MyProfileView()) {
        EmptyView()
      }
      .opacity(0.0) // 为了隐藏 NavigationLink 右边的箭头

      HStack(spacing: 16) {
        URLPlaceholderImage(me.avatar, size: .init(width: 64, height: 64)) {
          avatarPlaceholder
        }
        .background(.app_bg)
        .cornerRadius(6)

        VStack(alignment: .leading, spacing: 5) {
          Text(me.name)
            .foregroundColor(.text_primary)
            .font(.system(size: 20, weight: .semibold))

          HStack(spacing: 2) {
            Text("\(Strings.general_wechat_id()): \(me.wechatId)")
              .font(.system(size: 14))
              .lineLimit(1)
            Image("icons_outlined_qr_code")
              .resize(.fill, .init(width: 14, height: 14))
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
      .resize(.fill, .init(width: 64, height: 64))
      .foregroundColor(.app_bg)
  }

  func MeItemRow(item: MeItem) -> some View {
    ImageTitleRow(
      image: item.iconImage,
      imageColor: item.iconForegroundColor,
      imageSize: .init(width: 24, height: 24),
      title: item.title,
      destination: { Text(item.title) }
    )
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

    var iconImage: Image {
      switch self {
      case .pay:
        return Image("icons_outlined_wechatpay")
      case .favorites:
        return Image("icons_outlined_colorful_favorites")
      case .stickerGallery:
        return Image("icons_outlined_sticker")
      case .settings:
        return Image("icons_outlined_setting")
      }
    }

    var iconForegroundColor: Color? {
      switch self {
      case .pay, .favorites:
        return nil
      case .stickerGallery:
        return .hex("F5C343")
      case .settings:
        return .hex("3C86E6")
      }
    }
  }
}

struct MeView_Previews: PreviewProvider {
  static var previews: some View {
    MeView()
  }
}
