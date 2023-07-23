import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

// 富文本
InlineSpan richNode(item, context) {
  TextStyle authorStyle =
      TextStyle(color: Theme.of(context).colorScheme.primary);
  List<InlineSpan> spanChilds = [];
  for (var i in item.modules.moduleDynamic.desc.richTextNodes) {
    if (i.type == 'RICH_TEXT_NODE_TYPE_TEXT') {
      spanChilds.add(
          TextSpan(text: i.origText, style: const TextStyle(height: 1.65)));
    }
    // @用户
    if (i.type == 'RICH_TEXT_NODE_TYPE_AT') {
      spanChilds.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => Get.toNamed('/member?mid=${i.rid}',
                    arguments: {'face': null}),
                child: Text(
                  ' ${i.text}',
                  style: authorStyle,
                ),
              ),
            ],
          ),
        ),
      );
    }
    // 话题
    if (i.type == 'RICH_TEXT_NODE_TYPE_TOPIC') {
      spanChilds.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            onTap: () {},
            child: Text(
              '${i.origText}',
              style: authorStyle,
            ),
          ),
        ),
      );
    }
    // 网页链接
    if (i.type == 'RICH_TEXT_NODE_TYPE_WEB') {
      spanChilds.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Icon(
            Icons.link,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
      spanChilds.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            onTap: () {
              Get.toNamed(
                '/webview',
                parameters: {'url': i.origText, 'type': 'url', 'pageTitle': ''},
              );
            },
            child: Text(
              i.text,
              style: authorStyle,
            ),
          ),
        ),
      );
    }
    // 投票
    if (i.type == 'RICH_TEXT_NODE_TYPE_VOTE') {
      spanChilds.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            onTap: () {
              String dynamicId = item.basic['comment_id_str'];
              Get.toNamed(
                '/webview',
                parameters: {
                  'url':
                      'https://t.bilibili.com/vote/h5/index/#/result?vote_id=${i.rid}&dynamic_id=${dynamicId}&isWeb=1',
                  'type': 'vote',
                  'pageTitle': '投票'
                },
              );
            },
            child: Text(
              '投票：${i.text}',
              style: authorStyle,
            ),
          ),
        ),
      );
    }
    // 表情
    if (i.type == 'RICH_TEXT_NODE_TYPE_EMOJI') {
      spanChilds.add(
        WidgetSpan(
          child: NetworkImgLayer(
            src: i.emoji.iconUrl,
            type: 'emote',
            width: i.emoji.size * 20,
            height: i.emoji.size * 20,
          ),
        ),
      );
    }
    // 抽奖
    if (i.type == 'RICH_TEXT_NODE_TYPE_LOTTERY') {
      spanChilds.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Icon(
            Icons.redeem_rounded,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
      spanChilds.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            onTap: () {},
            child: Text(
              '${i.origText} ',
              style: authorStyle,
            ),
          ),
        ),
      );
    }

    /// TODO 商品
    if (i.type == 'RICH_TEXT_NODE_TYPE_GOODS') {
      spanChilds.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Icon(
            Icons.shopping_bag_outlined,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
      spanChilds.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            onTap: () {},
            child: Text(
              '${i.text} ',
              style: authorStyle,
            ),
          ),
        ),
      );
    }
  }
  return TextSpan(
    children: spanChilds,
  );
}