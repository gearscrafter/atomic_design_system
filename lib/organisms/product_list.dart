import 'package:flutter/material.dart';
import '../molecules/product_card.dart';

class ProductList extends StatefulWidget {
  final List<ProductCard> products;
  final Function(int id)? productSelected;
  final VoidCallback? onTapProductSelected;
  final Function(bool isScrolling)? onScrollChange;
  final double aspectHeight;

  const ProductList({
    super.key,
    required this.products,
    this.productSelected,
    this.onTapProductSelected,
    this.onScrollChange,
    this.aspectHeight = 7,
  });

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  double _lastScrollPosition = 0.0;
  bool _isScrollingUp = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollUpdateNotification) {
          final currentScrollPosition = notification.metrics.pixels;
          _isScrollingUp = currentScrollPosition > _lastScrollPosition;
          _lastScrollPosition = currentScrollPosition;
          if (widget.onScrollChange != null) {
            widget.onScrollChange!(true);
          }
          setState(() {});
        } else if (notification is ScrollEndNotification) {
          if (widget.onScrollChange != null) {
            widget.onScrollChange!(false);
          }
        }
        return true;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GridView.builder(
            itemCount: widget.products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: (constraints.maxWidth /
                      (MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 5.2
                          : 1.2)) /
                  (constraints.maxHeight /
                      ((MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? widget.aspectHeight
                          : 0.5)),
            ),
            itemBuilder: (context, index) {
              final product = widget.products[index];
              return Center(
                child: GestureDetector(
                  onTap: () {
                    if (widget.productSelected != null) {
                      widget.productSelected!(product.id);
                      if (widget.onTapProductSelected != null) {
                        widget.onTapProductSelected!();
                      }
                    }
                  },
                  child: ProductCard(
                    id: product.id,
                    title: product.title,
                    category: product.category,
                    image: product.image,
                    price: product.price,
                    topBoxHeight: _isScrollingUp ? 80.0 : 70.0,
                    bottomBoxHeight: _isScrollingUp ? 0.0 : 10.0,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
