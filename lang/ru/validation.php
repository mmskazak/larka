<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Языковые ресурсы валидации
    |--------------------------------------------------------------------------
    |
    | Следующие языковые строки содержат сообщения об ошибках, используемые
    | классом валидатора.
    |
    */

    'accepted' => 'Поле :attribute должно быть принято.',
    'accepted_if' => 'Поле :attribute должно быть принято, когда :other равно :value.',
    'active_url' => 'Поле :attribute должно быть действительным URL.',
    'after' => 'Поле :attribute должно быть датой после :date.',
    'after_or_equal' => 'Поле :attribute должно быть датой после или равной :date.',
    'alpha' => 'Поле :attribute должно содержать только буквы.',
    'alpha_dash' => 'Поле :attribute должно содержать только буквы, цифры, дефисы и подчёркивания.',
    'alpha_num' => 'Поле :attribute должно содержать только буквы и цифры.',
    'array' => 'Поле :attribute должно быть массивом.',
    'ascii' => 'Поле :attribute должно содержать только однобайтовые буквенно-цифровые символы.',
    'before' => 'Поле :attribute должно быть датой до :date.',
    'before_or_equal' => 'Поле :attribute должно быть датой до или равной :date.',
    'between' => [
        'array' => 'Поле :attribute должно содержать от :min до :max элементов.',
        'file' => 'Размер файла в поле :attribute должен быть от :min до :max Кб.',
        'numeric' => 'Поле :attribute должно быть от :min до :max.',
        'string' => 'Поле :attribute должно быть от :min до :max символов.',
    ],
    'boolean' => 'Поле :attribute должно быть true или false.',
    'can' => 'Поле :attribute содержит недопустимое значение.',
    'confirmed' => 'Поле :attribute не совпадает с подтверждением.',
    'contains' => 'В поле :attribute отсутствует обязательное значение.',
    'current_password' => 'Неверный пароль.',
    'date' => 'Поле :attribute должно быть корректной датой.',
    'date_equals' => 'Поле :attribute должно быть датой, равной :date.',
    'date_format' => 'Поле :attribute не соответствует формату :format.',
    'decimal' => 'Поле :attribute должно иметь :decimal десятичных знаков.',
    'declined' => 'Поле :attribute должно быть отклонено.',
    'declined_if' => 'Поле :attribute должно быть отклонено, когда :other равно :value.',
    'different' => 'Поля :attribute и :other должны различаться.',
    'digits' => 'Поле :attribute должно содержать :digits цифр.',
    'digits_between' => 'Поле :attribute должно содержать от :min до :max цифр.',
    'dimensions' => 'Поле :attribute содержит изображение с недопустимыми размерами.',
    'distinct' => 'Поле :attribute содержит повторяющееся значение.',
    'doesnt_end_with' => 'Поле :attribute не должно заканчиваться одним из следующих значений: :values.',
    'doesnt_start_with' => 'Поле :attribute не должно начинаться с одного из следующих значений: :values.',
    'email' => 'Поле :attribute должно быть корректным email адресом.',
    'ends_with' => 'Поле :attribute должно заканчиваться одним из следующих значений: :values.',
    'enum' => 'Выбранное значение для :attribute недопустимо.',
    'exists' => 'Выбранное значение для :attribute недопустимо.',
    'extensions' => 'Поле :attribute должно иметь одно из следующих расширений: :values.',
    'file' => 'Поле :attribute должно быть файлом.',
    'filled' => 'Поле :attribute обязательно для заполнения.',
    'gt' => [
        'array' => 'Поле :attribute должно содержать более :value элементов.',
        'file' => 'Размер файла в поле :attribute должен быть больше :value Кб.',
        'numeric' => 'Поле :attribute должно быть больше :value.',
        'string' => 'Поле :attribute должно быть больше :value символов.',
    ],
    'gte' => [
        'array' => 'Поле :attribute должно содержать :value элементов или больше.',
        'file' => 'Размер файла в поле :attribute должен быть :value Кб или больше.',
        'numeric' => 'Поле :attribute должно быть :value или больше.',
        'string' => 'Поле :attribute должно быть :value символов или больше.',
    ],
    'hex_color' => 'Поле :attribute должно быть корректным HEX цветом.',
    'image' => 'Поле :attribute должно быть изображением.',
    'in' => 'Выбранное значение для :attribute недопустимо.',
    'in_array' => 'Поле :attribute не существует в :other.',
    'integer' => 'Поле :attribute должно быть целым числом.',
    'ip' => 'Поле :attribute должно быть корректным IP адресом.',
    'ipv4' => 'Поле :attribute должно быть корректным IPv4 адресом.',
    'ipv6' => 'Поле :attribute должно быть корректным IPv6 адресом.',
    'json' => 'Поле :attribute должно быть корректной JSON строкой.',
    'list' => 'Поле :attribute должно быть списком.',
    'lowercase' => 'Поле :attribute должно быть в нижнем регистре.',
    'lt' => [
        'array' => 'Поле :attribute должно содержать менее :value элементов.',
        'file' => 'Размер файла в поле :attribute должен быть меньше :value Кб.',
        'numeric' => 'Поле :attribute должно быть меньше :value.',
        'string' => 'Поле :attribute должно быть меньше :value символов.',
    ],
    'lte' => [
        'array' => 'Поле :attribute должно содержать не более :value элементов.',
        'file' => 'Размер файла в поле :attribute должен быть :value Кб или меньше.',
        'numeric' => 'Поле :attribute должно быть :value или меньше.',
        'string' => 'Поле :attribute должно быть :value символов или меньше.',
    ],
    'mac_address' => 'Поле :attribute должно быть корректным MAC адресом.',
    'max' => [
        'array' => 'Поле :attribute не должно содержать более :max элементов.',
        'file' => 'Размер файла в поле :attribute не должен превышать :max Кб.',
        'numeric' => 'Поле :attribute не должно быть больше :max.',
        'string' => 'Поле :attribute не должно быть больше :max символов.',
    ],
    'max_digits' => 'Поле :attribute не должно содержать более :max цифр.',
    'mimes' => 'Поле :attribute должно быть файлом одного из типов: :values.',
    'mimetypes' => 'Поле :attribute должно быть файлом одного из типов: :values.',
    'min' => [
        'array' => 'Поле :attribute должно содержать не менее :min элементов.',
        'file' => 'Размер файла в поле :attribute должен быть не менее :min Кб.',
        'numeric' => 'Поле :attribute должно быть не менее :min.',
        'string' => 'Поле :attribute должно быть не менее :min символов.',
    ],
    'min_digits' => 'Поле :attribute должно содержать не менее :min цифр.',
    'missing' => 'Поле :attribute должно отсутствовать.',
    'missing_if' => 'Поле :attribute должно отсутствовать, когда :other равно :value.',
    'missing_unless' => 'Поле :attribute должно отсутствовать, если :other не равно :value.',
    'missing_with' => 'Поле :attribute должно отсутствовать, когда присутствует :values.',
    'missing_with_all' => 'Поле :attribute должно отсутствовать, когда присутствуют :values.',
    'multiple_of' => 'Поле :attribute должно быть кратным :value.',
    'not_in' => 'Выбранное значение для :attribute недопустимо.',
    'not_regex' => 'Формат поля :attribute недопустим.',
    'numeric' => 'Поле :attribute должно быть числом.',
    'password' => [
        'letters' => 'Поле :attribute должно содержать хотя бы одну букву.',
        'mixed' => 'Поле :attribute должно содержать хотя бы одну заглавную и одну строчную букву.',
        'numbers' => 'Поле :attribute должно содержать хотя бы одну цифру.',
        'symbols' => 'Поле :attribute должно содержать хотя бы один символ.',
        'uncompromised' => 'Указанный :attribute обнаружен в утечке данных. Пожалуйста, выберите другой :attribute.',
    ],
    'present' => 'Поле :attribute должно присутствовать.',
    'present_if' => 'Поле :attribute должно присутствовать, когда :other равно :value.',
    'present_unless' => 'Поле :attribute должно присутствовать, если :other не равно :value.',
    'present_with' => 'Поле :attribute должно присутствовать, когда присутствует :values.',
    'present_with_all' => 'Поле :attribute должно присутствовать, когда присутствуют :values.',
    'prohibited' => 'Поле :attribute запрещено.',
    'prohibited_if' => 'Поле :attribute запрещено, когда :other равно :value.',
    'prohibited_unless' => 'Поле :attribute запрещено, если :other не находится в :values.',
    'prohibits' => 'Поле :attribute запрещает присутствие :other.',
    'regex' => 'Формат поля :attribute недопустим.',
    'required' => 'Поле :attribute обязательно для заполнения.',
    'required_array_keys' => 'Поле :attribute должно содержать записи для: :values.',
    'required_if' => 'Поле :attribute обязательно для заполнения, когда :other равно :value.',
    'required_if_accepted' => 'Поле :attribute обязательно для заполнения, когда :other принято.',
    'required_if_declined' => 'Поле :attribute обязательно для заполнения, когда :other отклонено.',
    'required_unless' => 'Поле :attribute обязательно для заполнения, если :other не находится в :values.',
    'required_with' => 'Поле :attribute обязательно для заполнения, когда присутствует :values.',
    'required_with_all' => 'Поле :attribute обязательно для заполнения, когда присутствуют :values.',
    'required_without' => 'Поле :attribute обязательно для заполнения, когда отсутствует :values.',
    'required_without_all' => 'Поле :attribute обязательно для заполнения, когда отсутствуют :values.',
    'same' => 'Поля :attribute и :other должны совпадать.',
    'size' => [
        'array' => 'Поле :attribute должно содержать :size элементов.',
        'file' => 'Размер файла в поле :attribute должен быть :size Кб.',
        'numeric' => 'Поле :attribute должно быть :size.',
        'string' => 'Поле :attribute должно быть :size символов.',
    ],
    'starts_with' => 'Поле :attribute должно начинаться с одного из следующих значений: :values.',
    'string' => 'Поле :attribute должно быть строкой.',
    'timezone' => 'Поле :attribute должно быть корректным часовым поясом.',
    'unique' => 'Такое значение поля :attribute уже существует.',
    'uploaded' => 'Загрузка поля :attribute не удалась.',
    'uppercase' => 'Поле :attribute должно быть в верхнем регистре.',
    'url' => 'Формат поля :attribute недопустим.',
    'ulid' => 'Поле :attribute должно быть корректным ULID.',
    'uuid' => 'Поле :attribute должно быть корректным UUID.',

    /*
    |--------------------------------------------------------------------------
    | Пользовательские языковые ресурсы валидации
    |--------------------------------------------------------------------------
    |
    | Здесь вы можете указать пользовательские сообщения для атрибутов.
    |
    */

    'custom' => [
        'attribute-name' => [
            'rule-name' => 'custom-message',
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Пользовательские названия атрибутов
    |--------------------------------------------------------------------------
    |
    | Следующие строки используются для замены названий атрибутов.
    |
    */

    'attributes' => [
        'name' => 'имя',
        'username' => 'имя пользователя',
        'email' => 'email',
        'password' => 'пароль',
        'password_confirmation' => 'подтверждение пароля',
    ],

];
