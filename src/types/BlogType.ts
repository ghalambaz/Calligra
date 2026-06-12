export interface Blog {
    id: string;
    slug: string;
    body: string;
    data: {
        title: string;
        description: string;
        datetime: string;
        image?: string;
        category: string;
        tags: string[];
    }
}
