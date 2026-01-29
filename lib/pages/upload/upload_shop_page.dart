class UploadShopPage extends StatefulWidget {
const UploadShopPage({super.key});


@override
State<UploadShopPage> createState() => _UploadShopPageState();
}


class _UploadShopPageState extends State<UploadShopPage> {
final _formKey = GlobalKey<FormState>();
final nameCtrl = TextEditingController();
final addrCtrl = TextEditingController();


List<PickedImage> images = [];


Future<void> submit() async {
if (!_formKey.currentState!.validate()) return;
if (images.isEmpty) return;


await ShopApi.uploadShop(
name: nameCtrl.text,
address: addrCtrl.text,
images: images.map((e) => e.file).toList(),
);
}


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: const Text('上传店铺')),
body: Padding(
padding: const EdgeInsets.all(16),
child: Form(
key: _formKey,
child: ListView(
children: [
TextFormField(
}