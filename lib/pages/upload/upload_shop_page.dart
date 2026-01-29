import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../models/shop_model.dart';
import '../../services/shop_api.dart';
import '../../widgets/image_grid.dart';

class UploadShopPage extends StatefulWidget {
  const UploadShopPage({super.key});

  @override
  State<UploadShopPage> createState() => _UploadShopPageState();
}

class _UploadShopPageState extends State<UploadShopPage> {
  final _formController = TDFormController();
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final addrCtrl = TextEditingController();
  final Map<String, TDFormItemNotifier> _formItemNotifier = {
    'name': TDFormItemNotifier(),
    'address': TDFormItemNotifier(),
  };

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
    final theme = TDTheme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('上传店铺')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TDForm(
                formController: _formController,
                formContentAlign: TextAlign.left,
                requiredMark: true,
                formShowErrorMessage: true,
                items: [
                  TDFormItem(
                    label: '店铺名称',
                    name: 'name',
                    type: TDFormItemType.input,
                    help: '请输入店铺名称',
                    labelWidth: 82.0,
                    formItemNotifier: _formItemNotifier['name'],
                    showErrorMessage: true,
                    requiredMark: true,
                    child: TDInput(
                      leftContentSpace: 0,
                      inputDecoration: InputDecoration(
                        hintText: '请输入店铺名称',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: theme.textColorPlaceholder),
                      ),
                      controller: nameCtrl,
                      additionInfoColor: theme.errorColor6,
                      showBottomDivider: false,
                      onChanged: (val) {
                        _formItemNotifier['name']?.upDataForm(val);
                      },
                      onClearTap: () {
                        nameCtrl.clear();
                        _formItemNotifier['name']?.upDataForm('');
                      },
                    ),
                  ),
                  TDFormItem(
                    label: '店铺地址',
                    name: 'address',
                    type: TDFormItemType.input,
                    help: '请输入店铺地址',
                    labelWidth: 82.0,
                    formItemNotifier: _formItemNotifier['address'],
                    showErrorMessage: true,
                    requiredMark: true,
                    child: TDInput(
                      leftContentSpace: 0,
                      inputDecoration: InputDecoration(
                        hintText: '请输入店铺地址',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: theme.textColorPlaceholder),
                      ),
                      controller: addrCtrl,
                      additionInfoColor: theme.errorColor6,
                      showBottomDivider: false,
                      onChanged: (val) {
                        _formItemNotifier['address']?.upDataForm(val);
                      },
                      onClearTap: () {
                        addrCtrl.clear();
                        _formItemNotifier['address']?.upDataForm('');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ImageGrid(
                images: images,
                onAdd: (image) => setState(() => images.add(image)),
                onRemove: (id) =>
                    setState(() => images.removeWhere((img) => img.id == id)),
              ),
              const SizedBox(height: 16),
              TDButton(
                type: TDButtonType.fill,
                theme: TDButtonTheme.primary,
                size: TDButtonSize.large,
                isBlock: true,
                text: '提交',
                onTap: submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
