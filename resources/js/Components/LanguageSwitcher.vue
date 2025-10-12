<script setup>
import { useI18n } from 'vue-i18n';
import { ref } from 'vue';

const { locale } = useI18n();
const isOpen = ref(false);

const languages = [
    { code: 'ru', name: 'Русский' },
    { code: 'en', name: 'English' },
];

const changeLanguage = (lang) => {
    locale.value = lang;
    localStorage.setItem('locale', lang);
    isOpen.value = false;
};

const getCurrentLanguageName = () => {
    const current = languages.find((lang) => lang.code === locale.value);
    return current ? current.name : 'Русский';
};
</script>

<template>
    <div class="relative">
        <button
            @click="isOpen = !isOpen"
            class="flex items-center gap-2 rounded-md px-3 py-2 text-sm font-medium text-gray-700 transition hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-800"
        >
            <svg
                class="h-5 w-5"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
            >
                <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M3 5h12M9 3v2m1.048 9.5A18.022 18.022 0 016.412 9m6.088 9h7M11 21l5-10 5 10M12.751 5C11.783 10.77 8.07 15.61 3 18.129"
                />
            </svg>
            {{ getCurrentLanguageName() }}
        </button>

        <div
            v-show="isOpen"
            @click.away="isOpen = false"
            class="absolute right-0 z-10 mt-2 w-40 rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5 dark:bg-gray-800"
        >
            <div class="py-1">
                <button
                    v-for="lang in languages"
                    :key="lang.code"
                    @click="changeLanguage(lang.code)"
                    :class="[
                        'block w-full px-4 py-2 text-left text-sm transition',
                        locale === lang.code
                            ? 'bg-gray-100 text-gray-900 dark:bg-gray-700 dark:text-white'
                            : 'text-gray-700 hover:bg-gray-50 dark:text-gray-300 dark:hover:bg-gray-700',
                    ]"
                >
                    {{ lang.name }}
                </button>
            </div>
        </div>
    </div>
</template>
