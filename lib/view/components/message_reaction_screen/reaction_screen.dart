import 'package:audioplayers/audioplayers.dart';
import 'package:emdy_chat/configure/assets.dart';
import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/manager/user_manager.dart';
import 'package:emdy_chat/modal/message.dart';
import 'package:emdy_chat/util/popup_util.dart';
import 'package:emdy_chat/util/type_util.dart';
import 'package:emdy_chat/view/components/chat_page_component/message_item_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReactionScreen extends StatefulWidget {
  const ReactionScreen(
      {super.key, required this.messageContent, required this.message});

  final Widget messageContent;
  final Message message;

  @override
  State<ReactionScreen> createState() => _ReactionScreenState();
}

class _ReactionScreenState extends State<ReactionScreen>
    with TickerProviderStateMixin {
  late Size screenSize;
  late AnimationController animControlBox;
  late Animation fadeInBox;
  late Animation iconLike, iconLove, iconHaha, iconSad, iconWow, iconAngry;

  @override
  void initState() {
    super.initState();
    initAnimation();
    AudioPlayer().play(AssetSource(AssetsConfig.showReaction));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            width: reactBoxWidth,
            height: reactBoxHeight,
            decoration: BoxDecoration(
              color: ColorConfig.secondaryColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: AnimatedBuilder(
              animation: fadeInBox,
              builder: (context, child) => Opacity(
                opacity: fadeInBox.value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: ReactionType.listReact
                      .asMap()
                      .entries
                      .map(
                        (e) => GestureDetector(
                          onTap: () {
                            reactMessage(e.value);
                          },
                          child: Transform.scale(
                            scale: listAnimation[e.key].value,
                            child: Image.asset(
                              listIconSrc[e.key],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              AudioPlayer().play(AssetSource(AssetsConfig.hideReaction));
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: widget.messageContent,
            ),
          ),
          const Spacer(),
          MessageItemBottomSheet(message: widget.message),
        ],
      ),
    );
  }

  List<Animation> get listAnimation =>
      [iconLike, iconLove, iconHaha, iconSad, iconWow, iconAngry];

  List<String> get listIconSrc => [
        AssetsConfig.reactLike,
        AssetsConfig.reactLove,
        AssetsConfig.reactHaha,
        AssetsConfig.reactSad,
        AssetsConfig.reactWow,
        AssetsConfig.reactAngry
      ];

  double get reactBoxWidth => 260.0;

  double get reactBoxHeight => 40.0;

  CrossAxisAlignment get alignment => widget.message.senderId == UserManager.uid
      ? CrossAxisAlignment.end
      : CrossAxisAlignment.start;

  void reactMessage(int type) async {
    AudioPlayer().play(AssetSource(AssetsConfig.pickReaction));
    if (widget.message.react.containsKey(UserManager.uid) &&
        type == widget.message.react[UserManager.uid]) {
      await widget.message.removeReaction();
    } else {
      await widget.message.updateReaction(type).then((result) {
        if (!result) {
          PopupUtil.showSnackBar(
              context, AppLocalizations.of(context)!.reactMessageNotSuccess);
        }
      });
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void initAnimation() {
    animControlBox = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    // Box
    fadeInBox = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animControlBox,
      curve: const Interval(0.0, 1.0),
    ));
    iconLike = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.0, 0.17)),
    );
    iconLove = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: animControlBox, curve: const Interval(0.16, 0.34)),
    );
    iconHaha = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.33, 0.5)),
    );
    iconSad = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: animControlBox, curve: const Interval(0.49, 0.66)),
    );
    iconWow = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: animControlBox, curve: const Interval(0.66, 0.83)),
    );
    iconAngry = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animControlBox, curve: const Interval(0.82, 1)),
    );
    animControlBox.forward();
  }

  @override
  void dispose() {
    animControlBox.dispose();
    super.dispose();
  }
}
