# -*- coding: utf-8 -*-
module Amocrm
  class Contact < BaseResource

    # company_name  Название компании
    # type    Тип контакта: сontact или company
    # created_user_id   ID пользователя, создавшего контакт
    # linked_leads_id   Массив ID связанных сделок (сами сделки лежат в элементе leads, находящемся на уровне с contacts)
    # tags  Массив тегов
    # tags/id   Уникальный идентификатор тега
    # tags/name   Название тега (он же является и текстом)
    # custom_fields//id   Уникальный идентификатор дополнительного поля
    # custom_fields//name   Название дополнительного поля
    # custom_fields//code   Код поля. Установлен только у предустановленных полей
    # custom_fields//values   Массив, значений текущего доп поля
    # custom_fields//values//id   Уникальный идентификатор значения текущего доп поля
    # custom_fields//values//value  Значение текущего доп поля
    # custom_fields//values//enum   Значение списка
    # custom_fields//values//last_modified  Дата последнего изменения (передается в формате timestamp)
    # server_time   временная метка текущего серверного времени со смещением на часовой пояс аккаунта(передается в формате timestamp)

    create_attribute :name,            String
    create_attribute :company_name,    String
    create_attribute :type,            String
    create_attribute :created_user_id, Integer
    create_attribute :linked_lead_id,  Array
    create_attribute :tags,            Amocrm::Tags
    create_attribute :custom_fields,   Amocrm::CustomFields
    create_attribute :server_time,     DateTime

  end
end
