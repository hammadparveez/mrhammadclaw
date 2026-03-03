package ai.mrhammadclaw.android.ui

import androidx.compose.runtime.Composable
import ai.mrhammadclaw.android.MainViewModel
import ai.mrhammadclaw.android.ui.chat.ChatSheetContent

@Composable
fun ChatSheet(viewModel: MainViewModel) {
  ChatSheetContent(viewModel = viewModel)
}
