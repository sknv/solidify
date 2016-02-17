def replace_return_reason_or_create(old_name, new_name)
  return_reason = Spree::ReturnReason.find_by(name: old_name)
  if return_reason.present?
    return_reason.update_attribute(:name, new_name)
  else
    Spree::ReturnReason.create(name: new_name)
  end
end

replace_return_reason_or_create('Better price available',
                                'Есть более выгодная цена')
replace_return_reason_or_create('Missed estimated delivery date',
                                'Заказ не доставлен вовремя')
replace_return_reason_or_create('Missing parts or accessories',
                                'Заказ укомлектован неполностью')
replace_return_reason_or_create('Damaged/Defective',
                                'Товары повреждены или содержат дефекты')
replace_return_reason_or_create('Different from what was ordered',
                                'Заказаны другие товары')
replace_return_reason_or_create('Different from description',
                                'Товары отличаются от представленных на сайте')
replace_return_reason_or_create('No longer needed/wanted',
                                'Товары больше не нужны')
replace_return_reason_or_create('Accidental order',
                                'Заказ был произведен случайно')
replace_return_reason_or_create('Unauthorized purchase',
                                'Неавторизованный заказ')
