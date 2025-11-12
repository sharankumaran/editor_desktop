// ignore_for_file: public_member_api_docs, sort_constructors_first
enum WidgetType { textblock, imageBlock, videoBlock, liveData }

class WidgetItem {
  String id;
  WidgetType type;
  Map<String, dynamic> props;
  double left;
  double top;
  double width;
  double height;
  int zIndex;

  WidgetItem({
    required this.id,
    required this.type,
    required this.props,
    this.left = 24,
    this.top = 120,
    this.width = 750,
    this.height = 200,
    this.zIndex = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString().split('.').last,
    'props': props,
    'left': left,
    'top': top,
    'width': width,
    'height': height,
    'zIndex': zIndex,
  };

  static WidgetItem fromJson(Map<String, dynamic> j) {
    final t = WidgetType.values.firstWhere(
      (e) => e.toString().split('.').last == j['type'],
    );
    return WidgetItem(
      id: j['id'],
      type: t,
      props: Map<String, dynamic>.from(j['props'] ?? {}),
      left: (j['left'] ?? 20).todouble(),
      top: (j['top'] ?? 20).todouble(),
      width: (j['width'] ?? 350).todouble(),
      height: (j['height'] ?? 150).todouble(),
      zIndex: (j['zIndex'] ?? 0) as int,
    );
  }
}
