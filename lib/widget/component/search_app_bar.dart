import 'package:flutter/material.dart';

class SearchAppBar extends AppBar {
  SearchAppBar({
    super.key,
    String? query,
    Function(BuildContext)? onActionButtonTap,
    Function(String)? onSearchQueryChanged,
    Function(BuildContext, String)? onSearchQuerySubmitted
  }) : super(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    elevation: 0,
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(20),
      child: Builder(
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.topCenter,
            child: Row(
              children: [
                Expanded(
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(15),
                    child: TextFormField(
                      initialValue: query,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade700),
                        hintText: 'Search location...',
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      onChanged: onSearchQueryChanged,
                      onFieldSubmitted: (query) {
                        onSearchQuerySubmitted?.call(context, query);
                      },
                    )
                  ),
                ),
                const SizedBox(width: 10),
                Material(
                  elevation: 10,
                  color: Colors.orange.shade700,
                  borderRadius: BorderRadius.circular(15),
                  child: IconButton(
                    icon: const Icon(Icons.my_location, color: Colors.white),
                    onPressed: onActionButtonTap != null ? () {
                      onActionButtonTap(context);
                    } : null
                  )
                )
              ],
            )
          );
        }
      )
    ),
  );
}
